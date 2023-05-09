import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dietic_mobil/model/health_model.dart';
import 'package:dietic_mobil/service/health/health_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:flutter/services.dart';
import 'package:health/health.dart';
import '../../config/theme/theme.dart';
import '../../dietician-screen/home/widget/appbar.dart';

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

  @override
  void initState() {
    super.initState();
    Future fetchData() async {
      setState(() => _state = AppState.FETCHING_DATA);

      // get data within the last 24 hours
      final now = DateTime.now();
      final yesterday = now.subtract(Duration(hours: 24));

      // Clear old data points
      _healthDataList.clear();

      try {
        // fetch health data
        List<HealthDataPoint> healthData =
            await health.getHealthDataFromTypes(yesterday, now, types);
        // save all the new data points (only the first 100)
        _healthDataList.addAll((healthData.length < 100)
            ? healthData
            : healthData.sublist(0, 100));
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

      // print the results
      _healthDataList.forEach((x) => print(x));

      // update the UI to display the results
      setState(() {
        _state =
            _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
      });
    }

    healthService.fetchWeekStepData().then((value) {
      if (value != null) {
        setState(() {
          stepWeekData = value;
          //stepWeekData = HealthFactory.removeDuplicates(stepWeekData!);
          for (int i = 0; i < stepWeekData!.length; i++) {
            print(stepWeekData![i]);
          }
        });
      } else {
        throw Exception('company data null came');
      }
    });
    healthService.fetchWaterData().then((value) {
      if (value != null) {
        setState(() {
          waterData = value;
          print('water');
          print(waterData);
        });
      } else {
        throw Exception('company data null came');
      }
    });
    healthService.fetchEnergyData();
    healthService.fetchTodayStepData();
  }

  final storage = new FlutterSecureStorage();

  Future<String?> getMoveData() async {
    String? move_mins = await storage.read(key: 'move_min');
    return move_mins;
  }

  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(Icons.directions_run,
                                            size: 30,
                                            color: Colors.amberAccent),
                                        Text('${stepWeekData ?? 0}')
                                      ],
                                    ),
                                    Text('Water',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15)),
                                    Text('%30'),
                                    LinearPercentIndicator(
                                        barRadius: Radius.circular(20),
                                        width: 130,
                                        animation: true,
                                        animationDuration: 10000,
                                        lineHeight: 10,
                                        percent: 0.3,
                                        progressColor: Colors.amberAccent,
                                        backgroundColor: Color(0xfffaf1be))
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 170,
                              width: 170,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: FutureBuilder(
                                    future: healthService.fetchTodayStepData(),
                                    builder: (context, snapshot) {
                                      double _percent = double.parse(
                                              snapshot.data != null
                                                  ? snapshot.data!
                                                  : '0') /
                                          15000;
                                      String percentNumber =
                                          (_percent * 100).toStringAsFixed(2);
                                      if (_percent > 1) {
                                        _percent = 0.99;
                                      } else if (_percent == null) {
                                        _percent = 0.1;
                                      }
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Icon(Icons.directions_walk,
                                                  size: 30,
                                                  color: Colors.pinkAccent),
                                              if (snapshot.data!=null) Text('0') else Text(snapshot.data)
                                            ],
                                          ),
                                          Text('Steps',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18)),
                                          Text("%${percentNumber}" ?? ' '),
                                          LinearPercentIndicator(
                                            barRadius: Radius.circular(20),
                                            width: 130,
                                            animation: true,
                                            animationDuration: 10000,
                                            lineHeight: 10,
                                            percent: _percent ?? 0.0,
                                            progressColor: Colors.pinkAccent,
                                            backgroundColor: Color(0xffE0A0B2),
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25),
                ///////////////////////////////////////////////////////////
                //Carousel
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
                      FutureBuilder(
                          future: healthService.fetchWeekStepData(),
                          builder: (context, snapshot) {
                            /* var result=snapshot.data!.value!.numericValue;
                        print(result);*/
                            //  var steps=double.parse(snapshot.data.value.numericValue) ?? 0;
                            print('asdasdasdasdasd');
                            return Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[600],
                                    borderRadius: BorderRadius.circular(24)),
                                padding: const EdgeInsets.all(20.0),
                                alignment: Alignment.center,
                                width: 250.0,
                                height: 250.0,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'Steps',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      height: 220,
                                      child: SfSparkLineChart(
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          // enable the trackball
                                          trackball: SparkChartTrackball(
                                            activationMode:
                                                SparkChartActivationMode.tap,
                                          ),
                                          // enable marker
                                          marker: SparkChartMarker(
                                            displayMode:
                                                SparkChartMarkerDisplayMode.all,
                                          ),
                                          // enable data label
                                          labelDisplayMode:
                                              SparkChartLabelDisplayMode.all,
                                          // use different data for each chart
                                          data: <double>[0, 23, 4, 5, 69]),
                                    ),
                                  ],
                                ));
                          }),
                      Container(
                          decoration: BoxDecoration(
                              color: AppColors.colorBackColor,
                              borderRadius: BorderRadius.circular(24)),
                          padding: const EdgeInsets.all(20.0),
                          alignment: Alignment.center,
                          width: 250.0,
                          height: 250.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Weight',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                height: 220,
                                child: SfSparkLineChart(
                                    labelStyle: TextStyle(color: Colors.black),
                                    // enable the trackball
                                    trackball: SparkChartTrackball(
                                      activationMode:
                                          SparkChartActivationMode.tap,
                                    ),
                                    // enable marker
                                    marker: SparkChartMarker(
                                      displayMode:
                                          SparkChartMarkerDisplayMode.all,
                                    ),
                                    // enable data label
                                    labelDisplayMode:
                                        SparkChartLabelDisplayMode.all,
                                    // use different data for each chart
                                    data: <double>[
                                      92,
                                      89,
                                      85,
                                      84,
                                      83,
                                      82,
                                    ]),
                              ),
                            ],
                          )),
                    ]),
                    ListHealthData(),
                /*SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: healthDataPoints.length,
                    itemBuilder: (BuildContext context, int index) {
                      HealthDataPoint dataPoint = healthDataPoints[index];
                      return ListTile(
                        title: Text('Step Count: ${dataPoint.value}'),
                        subtitle: Text('Date: ${dataPoint.dateFrom}'),
                      );
                    },
                  ),
                )  */
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: _healthDataList.length,
                    itemBuilder: (_, index) {
                      HealthDataPoint p = _healthDataList[index];
                      if (p.value is AudiogramHealthValue) {
                        return ListTile(
                          title: Text("${p.typeString}: ${p.value}"),
                          trailing: Text('${p.unitString}'),
                          subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
                        );
                      }
                      if (p.value is WorkoutHealthValue) {
                        return ListTile(
                          title: Text(
                              "${p.typeString}: ${(p.value as WorkoutHealthValue).totalEnergyBurned} ${(p.value as WorkoutHealthValue).totalEnergyBurnedUnit?.name}"),
                          trailing: Text(
                              '${(p.value as WorkoutHealthValue).workoutActivityType.name}'),
                          subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
                        );
                      }
                      return ListTile(
                        title: Text("${p.typeString}: ${p.value}"),
                        trailing: Text('${p.unitString}'),
                        subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
                      );
                    }),
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
                              '${snapshot.data} kcal',
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
  Widget ListHealthData(){
    return ListView.builder(
      shrinkWrap: true,
        itemCount: _healthDataList.length,
        itemBuilder: (context, index) {
          HealthDataPoint p = _healthDataList[index];
          if (p.value is AudiogramHealthValue) {
            return ListTile(
              title: Text("${p.typeString}: ${p.value}"),
              trailing: Text('${p.unitString}'),
              subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
            );
          }
          if (p.value is WorkoutHealthValue) {
            return ListTile(
              title: Text(
                  "${p.typeString}: ${(p.value as WorkoutHealthValue).totalEnergyBurned} ${(p.value as WorkoutHealthValue).totalEnergyBurnedUnit?.name}"),
              trailing: Text(
                  '${(p.value as WorkoutHealthValue).workoutActivityType.name}'),
              subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
            );
          }
          return ListTile(
            title: Text("${p.typeString}: ${p.value}"),
            trailing: Text('${p.unitString}'),
            subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
          );
        });
  }
}
