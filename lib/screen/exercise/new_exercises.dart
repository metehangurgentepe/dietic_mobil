import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Dietic/model/health_model.dart';
import 'package:Dietic/model/steps_model.dart';
import 'package:Dietic/service/health/health_service.dart';
import 'package:Dietic/service/weight/weight_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grock/grock.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:flutter/services.dart';
import 'package:health/health.dart';
import '../../config/theme/theme.dart';
import '../../dietician-screen/home/widget/appbar.dart';
import '../../model/weight_model.dart';
import '../../service/steps/steps_service.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:permission_handler/permission_handler.dart';

class NewExercises extends ConsumerStatefulWidget {
  const NewExercises({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewExercisesState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTHORIZED,
  AUTH_NOT_GRANTED,
  DATA_ADDED,
  DATA_DELETED,
  DATA_NOT_ADDED,
  DATA_NOT_DELETED,
  STEPS_READY,
}

class _NewExercisesState extends ConsumerState<NewExercises> {
  Future<List<HealthDataPoint>>? weekSteps;
  final List<HealthDataPoint> healthDataPoints = [];
  HealthService healthService = HealthService();

  List<HealthDataPoint>? stepWeekData;
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;
  int _nofSteps = 0;

  List<WeightModel> weightsData = [];
  List<double> weights = [];
  List<String> date = [];
  List<String> stepsDate = [];
  ValueNotifier<List<double>> weightsValue = ValueNotifier<List<double>>([]);

  final service = WeightService();
  final stepService = StepService();
  List<FlSpot> weightFl = [];
  List<FlSpot> stepsFl = [];

  var waterData;
  static final types = [
    HealthDataType.WEIGHT,
    HealthDataType.STEPS,
    HealthDataType.HEIGHT,
    HealthDataType.BLOOD_GLUCOSE,
    HealthDataType.WORKOUT,
    HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    // Uncomment these lines on iOS - only available on iOS
    // HealthDataType.AUDIOGRAM
  ];

  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff23b6e6),
  ];
  final firestore = FirebaseFirestore.instance;

  String? water;
  Timestamp? time;

  var waterNumberData = 0;
  List<int> step = [];
  String? heartRate;
  String? bp;
  String? steps;
  String? activeEnergy;

  String? bloodPreSys;
  String? bloodPreDia;
  int stepDatas = 0;
  double percent=0;

  List<HealthDataPoint> healthData = [];

  HealthFactory health = HealthFactory();
  final permissions = types.map((e) => HealthDataAccess.READ).toList();

  Future authorize() async {
    // If we are trying to read Step Count, Workout, Sleep or other data that requires
    // the ACTIVITY_RECOGNITION permission, we need to request the permission first.
    // This requires a special request authorization call.
    //
    // The location permission is requested for Workouts using the Distance information.
    await Permission.activityRecognition.request();
    await Permission.location.request();

    // Check if we have permission
    bool? hasPermissions =
        await health.hasPermissions(types, permissions: permissions);

    // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
    // Hence, we have to request with WRITE as well.
    hasPermissions = false;

    bool authorized = false;
    if (!hasPermissions) {
      // requesting access to the data types before reading them
      try {
        authorized =
            await health.requestAuthorization(types, permissions: permissions);
      } catch (error) {
        print("Exception in authorize: $error");
      }
    }
    setState(() => _state =
        (authorized) ? AppState.AUTHORIZED : AppState.AUTH_NOT_GRANTED);
  }

  Future fetchData() async {
    // define the types to get
    final types = [
      HealthDataType.HEART_RATE,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
    ];

    // get data within the last 24 hours
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    // requesting access to the data types before reading them
    bool requested = await health.requestAuthorization(types);
    print(requested);

    if (requested) {
      try {
        // fetch health data
        healthData = await health.getHealthDataFromTypes(yesterday, now, types);
        if (healthData.isNotEmpty) {
          for (HealthDataPoint h in healthData) {
            if (h.type == HealthDataType.HEART_RATE) {
              heartRate = "${h.value}";
            } else if (h.type == HealthDataType.BLOOD_PRESSURE_SYSTOLIC) {
              bloodPreSys = "${h.value}";
            } else if (h.type == HealthDataType.BLOOD_PRESSURE_DIASTOLIC) {
              bloodPreDia = "${h.value}";
            } else if (h.type == HealthDataType.STEPS) {
              steps = "${h.value}";
            } else if (h.type == HealthDataType.ACTIVE_ENERGY_BURNED) {
              activeEnergy = "${h.value}";
            }
          }
          if (bloodPreSys != "null" && bloodPreDia != "null") {
            bp = "$bloodPreSys / $bloodPreDia mmHg";
          }
          print(steps);
          print('buradadaaaddaada');

          setState(() {});
        }
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates
      healthData = HealthFactory.removeDuplicates(healthData);
    } else {
      print("Authorization not granted");
    }
  }

  @override
  void initState() {
    super.initState();
    authorize();
    fetchData();
    service.getWeights().then((value) {
      setState(() {
        weightsData = value;
        for (int i = 0; i < weightsData.length; i++) {
          weights.add(weightsData[i].weight!);
          date.add(weightsData[i].date!);
          weightsData[i].date!.substring(4, 9);
          weightFl.add(FlSpot(i.toDouble(), weightsData[i].weight!));
        }
        weightsValue = ValueNotifier<List<double>>(weights);
      });
    });
    healthService.fetchTodayStepData().then((value) {
      setState(() {
        stepDatas = value;
        print(stepDatas);
      });
    });
  }

  final storage = new FlutterSecureStorage();

  Future<String?> getMoveData() async {
    String? move_mins = await storage.read(key: 'move_min');
    return move_mins;
  }

  getWater() async {
    water = await storage.read(key: 'water');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //app bar(date and calendar)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: HomeScreenAppBar(),
                ),
                //calories circle
                _circleProgress(),
                SizedBox(height: 25),
                //todays goals
                Container(
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Today's Goals",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StreamBuilder(
                                stream:
                                    firestore.collection('Water').snapshots(),
                                builder: (context, snapshot) {
                                  DateTime date = DateTime.now();
                                  List data = !snapshot.hasData
                                      ? []
                                      : snapshot.data!.docs
                                          .where((element) => element['email']
                                              .toString()
                                              .contains(FirebaseAuth
                                                  .instance.currentUser!.uid))
                                          .toList();
                                  if (data.isNotEmpty) {
                                    for (int i = 0; i < 1; i++) {
                                      time = data[i]['datetime'];
                                      if (time!.toDate().day == date.day) {
                                        waterNumberData = data[i]['water'];
                                      } else {
                                        time = null;
                                      }
                                    }
                                  } else {
                                    waterNumberData = 0;
                                  }
                                  return Container(
                                    height: 170,
                                    width: 170,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Icon(Icons.water,
                                                  size: 30,
                                                  color: Colors.blueAccent),
                                              Text('${waterNumberData} mL')
                                            ],
                                          ),
                                          Text('Water',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15)),
                                          waterNumberData == null
                                              ? Text('%0')
                                              : Text(
                                                  '%${(waterNumberData / 2500 * 100).toInt()}'),
                                          LinearPercentIndicator(
                                              barRadius: Radius.circular(20),
                                              width: 130,
                                              animation: true,
                                              animationDuration: 10000,
                                              lineHeight: 10,
                                              percent: (waterNumberData / 2500),
                                              progressColor: Colors.blueAccent,
                                              backgroundColor: Color.fromARGB(
                                                  255, 64, 202, 241))
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                            Container(
                              height: 170,
                              width: 170,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FutureBuilder(
                                        future: healthService.fetchEnergyData(),
                                        builder: (context, snapshot) {
                                          saveEnergy() async {
                                             String value=snapshot.data;
                                            print(snapshot.data);
                                            if (snapshot.data != null) {
                                              var value = snapshot.data;
                                              await storage.write(
                                                  key: 'activeCalories',
                                                  value: value);
                                            } else {
                                              await storage.write(
                                                  key: 'activeCalories',
                                                  value: '0');
                                            }
                                          percent=int.parse(value)/10000;
                                          if(percent>1){
                                            percent=1;
                                          }
                                          print(percent);
                                          }
                                          saveEnergy();
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Icon(Icons.directions_walk,
                                                      size: 30,
                                                      color: Colors.pinkAccent),
                                                  Text(
                                                    '${snapshot.data}',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                            ],
                                          );
                                        }),
                                    Text('Steps',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18)),
                                    Text("%${percent*100}"),
                                    LinearPercentIndicator(
                                      barRadius: Radius.circular(20),
                                      width: 130,
                                      animation: true,
                                      animationDuration: 10000,
                                      lineHeight: 10,
                                      percent: percent,
                                      progressColor: Colors.pinkAccent,
                                      backgroundColor: Color(0xffE0A0B2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25),
                CarouselSlider(
                    options: CarouselOptions(
                      height: 400.0,
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: false,
                      viewportFraction: 0.8,
                    ),
                    items: [
                      Column(
                        children: [
                          Center(
                            child: Text(
                              'Weights',
                              style: TextStyle(
                                color: AppColors.colorAccentDark,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          SizedBox(height: 300, child: LineChart(weightData())),
                        ],
                      ),
                      // Column(
                      //   children: [
                      //     Center(
                      //       child: Text(
                      //         'Steps',
                      //         style: TextStyle(
                      //           color: AppColors.colorAccentDark,
                      //           fontSize: 32,
                      //           fontWeight: FontWeight.bold,
                      //           letterSpacing: 2,
                      //         ),
                      //       ),
                      //     ),
                      //     SizedBox(height: 300, child: LineChart(stepData())),
                      //   ],
                      // ),
                      // charts.BarChart(
                      //   series,
                      //   animate: true,
                      // ),
                    ]),
                SizedBox(height: 100),
              ]),
        ),
      ),
    );
  }

  Widget _circleProgress() {
    return SizedBox(
      width: 250.w,
      height: 250.w,
      child: Stack(
        children: [
          SizedBox(
            width: 250.w,
            height: 250.w,
            child: CircularProgressIndicator(
              strokeWidth: 8.w,
              value: 0.7,
              backgroundColor: AppColors.colorTint100.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorAccent),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              margin: EdgeInsets.all(13.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.colorAccent.withOpacity(0.2), width: 8.w),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.colorAccent.withOpacity(0.1),
                ),
                child: Container(
                  margin: EdgeInsets.all(22.w),
                  child: FutureBuilder(
                      future: healthService.fetchEnergyData(),
                      builder: (context, snapshot) {
                        saveEnergy() async {
                          print(snapshot.data);
                          if (snapshot.data != null) {
                            var value = snapshot.data;
                            await storage.write(
                                key: 'activeCalories', value: value);
                          } else {
                            await storage.write(
                                key: 'activeCalories', value: '0');
                          }
                        }

                        //saveEnergy();
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Active Calories',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 20.sp,
                              ),
                            ),
                            Text(
                              snapshot.data == null
                                  ? '0 kcal'
                                  : '${snapshot.data} kcal',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        );
                      }),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    List<String> times = [];
    final now = DateTime.now();
    String day = '${(now.month).toString()}-${(now.day + 7).toString()}';
    for (int i = 0; i < date.length; i++) {
      times.add(date[i]);
    }

    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 7,
    );
    Widget text = Text(day);
    if (date.length == 0) {
      switch (value.toInt()) {
        default:
          text = Text('${(now.month).toString()}-${(now.day + 7).toString()}',
              style: style);
          break;
      }
    } else if (date.isNotEmpty) {
      for (int i = 0; i < date.length; i++) {
        text = Text(date[i].substring(5, 10), style: style);
      }
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget bottomTitleStepWidgets(double value, TitleMeta meta) {
    final now = DateTime.now();
    String day = '${(now.month).toString()}-${(now.day + 7).toString()}';

    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 7,
    );
    Widget text = Text(day);
    if (stepsDate.length == 0) {
      switch (value.toInt()) {
        default:
          text = Text('${(now.month).toString()}-${(now.day + 7).toString()}',
              style: style);
          break;
      }
    } else if (stepsDate.isNotEmpty) {
      for (int i = 0; i < stepsDate.length; i++) {
        text = Text(stepsDate[i].substring(5, 10), style: style);
      }
      print(text);
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 11,
    );
    String text;
    switch (value.toInt()) {
      case 50:
        text = '50KG';
        break;
      case 70:
        text = '70KG';
        break;
      case 90:
        text = '90KG';
        break;
      case 100:
        text = '100KG';
        break;

      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  Widget leftTitleStepWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 11,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 300:
        text = '3000';
        break;
      case 500:
        text = '5000';
        break;
      case 700:
        text = '7000';
        break;
      case 1000:
        text = '10000';
        break;
      case 1400:
        text = '14000';
        break;
      case 1800:
        text = '18000';
        break;

      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData weightData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: gradientColors[1],
            strokeWidth: 0.001,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: gradientColors[1],
            strokeWidth: 0.001,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: date.length.toDouble(),
      minY: 40,
      maxY: 130,
      lineBarsData: [
        LineChartBarData(
          spots: weightFl,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData stepData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: gradientColors[1],
            strokeWidth: 0.001,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: gradientColors[1],
            strokeWidth: 0.001,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleStepWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleStepWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Color.fromARGB(255, 180, 194, 205)),
      ),
      minX: 0,
      maxX: date.length.toDouble(),
      minY: 0,
      maxY: 19000,
      lineBarsData: [
        LineChartBarData(
          spots: stepsFl,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class OrdinalSales {
  final String month;
  final int sales;

  OrdinalSales(this.month, this.sales);
}
