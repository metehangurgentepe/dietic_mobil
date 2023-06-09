// import 'dart:convert';

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:dietic_mobil/model/health_model.dart';
// import 'package:dietic_mobil/model/steps_model.dart';
// import 'package:dietic_mobil/service/health/health_service.dart';
// import 'package:dietic_mobil/service/weight/weight_service.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:grock/grock.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:syncfusion_flutter_charts/sparkcharts.dart';
// import 'package:flutter/services.dart';
// import 'package:health/health.dart';
// import '../../config/theme/theme.dart';
// import '../../dietician-screen/home/widget/appbar.dart';
// import '../../model/weight_model.dart';
// import '../../service/steps/steps_service.dart';

// class NewExercises extends ConsumerStatefulWidget {
//   const NewExercises({Key? key}) : super(key: key);

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _NewExercisesState();
// }

// enum AppState {
//   DATA_NOT_FETCHED,
//   FETCHING_DATA,
//   DATA_READY,
//   NO_DATA,
//   AUTHORIZED,
//   AUTH_NOT_GRANTED,
//   DATA_ADDED,
//   DATA_DELETED,
//   DATA_NOT_ADDED,
//   DATA_NOT_DELETED,
//   STEPS_READY,
// }

// class _NewExercisesState extends ConsumerState<NewExercises> {
//   Future<List<HealthDataPoint>>? weekSteps;
//   final List<HealthDataPoint> healthDataPoints = [];
//   HealthService healthService = HealthService();

//   List<HealthDataPoint>? stepWeekData;
//   List<HealthDataPoint> _healthDataList = [];
//   AppState _state = AppState.DATA_NOT_FETCHED;
//   int _nofSteps = 0;

//   List<WeightModel> weightsData = [];
//   List<double> weights = [];
//   List<String> date = [];
//   List<String> stepsDate = [];
//   ValueNotifier<List<double>> weightsValue = ValueNotifier<List<double>>([]);

//   final service = WeightService();
//   final stepService = StepService();
//   List<FlSpot> weightFl = [];
//   List<FlSpot> stepsFl = [];

//   var waterData;
//   static final types = [
//     HealthDataType.WEIGHT,
//     HealthDataType.STEPS,
//     HealthDataType.HEIGHT,
//     HealthDataType.BLOOD_GLUCOSE,
//     HealthDataType.WORKOUT,
//     HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
//     HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
//     // Uncomment these lines on iOS - only available on iOS
//     // HealthDataType.AUDIOGRAM
//   ];

//   final List<Color> gradientColors = [
//     const Color(0xff23b6e6),
//     const Color(0xff23b6e6),
//   ];

//   List<StepsModel> steps = [];
//   String? water;

//   @override
//   void initState() {
//     super.initState();
//     getWater();
//     getdata() async {
//     String? dietitianId=await storage.read(key: 'patientId');
//     print(dietitianId);

//     }
//     getdata();
//     Future fetchData() async {
//       setState(() => _state = AppState.FETCHING_DATA);

//       // get data within the last 24 hours
//       final now = DateTime.now();
//       final yesterday = now.subtract(Duration(hours: 24));

//       // Clear old data points
//       _healthDataList.clear();

//       try {
//         // fetch health data
//         List<HealthDataPoint> healthData =
//             await health.getHealthDataFromTypes(yesterday, now, types);
//         // save all the new data points (only the first 100)
//         _healthDataList.addAll((healthData.length < 100)
//             ? healthData
//             : healthData.sublist(0, 100));
//       } catch (error) {
//         print("Exception in getHealthDataFromTypes: $error");
//       }

//       // filter out duplicates
//       _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

//       // print the results
//       _healthDataList.forEach((x) => print(x));

//       // update the UI to display the results
//       setState(() {
//         _state =
//             _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
//       });
//     }

//     healthService.fetchWeekStepData().then((value) {
//       if (value != null) {
//         setState(() {
//           stepWeekData = value;
//           //stepWeekData = HealthFactory.removeDuplicates(stepWeekData!);
//           for (int i = 0; i < stepWeekData!.length; i++) {
//             print(stepWeekData![i]);
//           }
//         });
//       } else {
//         throw Exception('company data null came');
//       }
//     });

    

//     healthService.fetchEnergyData();
//     healthService.fetchTodayStepData();

//     service.getWeights().then((value) {
//       setState(() {
//         weightsData = value;
//         for (int i = 0; i < weightsData.length; i++) {
//           weights.add(weightsData[i].weight!);
//           date.add(weightsData[i].date!);
//           weightsData[i].date!.substring(4, 9);
//           weightFl.add(FlSpot(i.toDouble(), weightsData[i].weight!));
//           print(weightsData[i].date!.substring(5, 9).replaceAll('-', '.'));
//         }
//         print('charttt');
//         weightsValue = ValueNotifier<List<double>>(weights);
//         print(weights);
//         print('zaman');
//         print(date);
//       });
//     });

//     stepService.getAllSteps().then((value) {
//       steps = value;
//       for (int i = 0; i < steps.length; i++) {
//         stepsFl.add(FlSpot(i.toDouble(), steps[i].steps!.toDouble()));
//         stepsDate.add(steps[i].date!);
//       }
//       print('flutter chart');
//       print(stepsFl);
//       print(stepsDate);
//     });
//   }

//   final storage = new FlutterSecureStorage();

//   Future<String?> getMoveData() async {
//     String? move_mins = await storage.read(key: 'move_min');
//     return move_mins;
//   }
//   getWater() async {
//     water= await storage.read(key: 'water');
//   }

//   HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               mainAxisSize: MainAxisSize.max,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 //app bar(date and calendar)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                   child: HomeScreenAppBar(),
//                 ),
//                 //calories circle
//                 _circleProgress(),
//                 SizedBox(height: 25),
//                 //todays goals
//                 Container(
//                   decoration: BoxDecoration(color: Colors.grey[200]),
//                   child: Padding(
//                     padding: const EdgeInsets.all(18.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Today's Goals",
//                             style: TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.w500)),
//                         SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Container(
//                               height: 170,
//                               width: 170,
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   shape: BoxShape.rectangle,
//                                   borderRadius: BorderRadius.circular(30)),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(20.0),
//                                 child: Column(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceAround,
//                                       children: [
//                                         Icon(Icons.water,
//                                             size: 30,
//                                             color: Colors.blueAccent),
//                                         Text('${water ?? 0} mL')
//                                       ],
//                                     ),
//                                     Text('Water',
//                                         style: TextStyle(
//                                             color: Colors.black, fontSize: 15)),
//                                      water ==null ? Text('%0')  :Text('%${(int.parse(water!)/2500*100).toInt()}'),
//                                     LinearPercentIndicator(
//                                         barRadius: Radius.circular(20),
//                                         width: 130,
//                                         animation: true,
//                                         animationDuration: 10000,
//                                         lineHeight: 10,
//                                         percent: 0.3,
//                                         progressColor: Colors.blueAccent,
//                                         backgroundColor: Color.fromARGB(255, 64, 202, 241))
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               height: 170,
//                               width: 170,
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   shape: BoxShape.rectangle,
//                                   borderRadius: BorderRadius.circular(30)),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(20.0),
//                                 child: FutureBuilder(
//                                     future: healthService.fetchTodayStepData(),
//                                     builder: (context, snapshot) {
//                                       print('snap');
//                                       print(snapshot.data.toString());
//                                       if (snapshot.data == null) {
//                                         return Text('No steps data today');
//                                       }
//                                       stepService.saveSteps(snapshot.data!);
//                                       double _percent = snapshot.data! / 15000;
//                                       String percentNumber =
//                                           (_percent * 100).toStringAsFixed(2);
//                                       if (_percent > 1) {
//                                         _percent = 0.99;
//                                       } else {
//                                         print('adım');
//                                         print(snapshot.data);
//                                         _percent ??= 0.1;
//                                       }
//                                       return Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceAround,
//                                             children: [
//                                               Icon(Icons.directions_walk,
//                                                   size: 30,
//                                                   color: Colors.pinkAccent),
//                                               Text(
//                                                 '${snapshot.data}',
//                                                 style: TextStyle(
//                                                     fontSize: 14,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               )
//                                             ],
//                                           ),
//                                           Text('Steps',
//                                               style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: 18)),
//                                           Text("%${percentNumber}" ?? ' '),
//                                           LinearPercentIndicator(
//                                             barRadius: Radius.circular(20),
//                                             width: 130,
//                                             animation: true,
//                                             animationDuration: 10000,
//                                             lineHeight: 10,
//                                             percent: _percent ?? 0.0,
//                                             progressColor: Colors.pinkAccent,
//                                             backgroundColor: Color(0xffE0A0B2),
//                                           ),
//                                         ],
//                                       );
//                                     }),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 25),
//                 CarouselSlider(
//                     options: CarouselOptions(
//                       height: 400.0,
//                       enlargeCenterPage: true,
//                       aspectRatio: 16 / 9,
//                       autoPlayCurve: Curves.fastOutSlowIn,
//                       enableInfiniteScroll: false,
//                       viewportFraction: 0.8,
//                     ),
//                     items: [
//                       Column(
//                         children: [
//                           Center(
//                             child: Text(
//                               'Weights',
//                               style: TextStyle(
//                                 color: AppColors.colorAccentDark,
//                                 fontSize: 32,
//                                 fontWeight: FontWeight.bold,
//                                 letterSpacing: 2,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 300, child: LineChart(weightData())),
//                         ],
//                       ),
//                       Column(
//                         children: [
//                           Center(
//                             child: Text(
//                               'Steps',
//                               style: TextStyle(
//                                 color: AppColors.colorAccentDark,
//                                 fontSize: 32,
//                                 fontWeight: FontWeight.bold,
//                                 letterSpacing: 2,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 300, child: LineChart(stepData())),
//                         ],
//                       ),
//                     ]),
//                 SizedBox(height: 100),
//               ]),
//         ),
//       ),
//     );
//   }

//   Widget _circleProgress() {
//     return SizedBox(
//       width: 250.w,
//       height: 250.w,
//       child: Stack(
//         children: [
//           SizedBox(
//             width: 250.w,
//             height: 250.w,
//             child: CircularProgressIndicator(
//               strokeWidth: 8.w,
//               value: 0.7,
//               backgroundColor: AppColors.colorTint100.withOpacity(0.2),
//               valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorAccent),
//             ),
//           ),
//           Align(
//             alignment: Alignment.center,
//             child: Container(
//               width: double.infinity,
//               height: double.infinity,
//               margin: EdgeInsets.all(13.w),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                     color: AppColors.colorAccent.withOpacity(0.2), width: 8.w),
//               ),
//               child: Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: AppColors.colorAccent.withOpacity(0.1),
//                 ),
//                 child: Container(
//                   margin: EdgeInsets.all(22.w),
//                   child: FutureBuilder(
//                       future: healthService.fetchEnergyData(),
//                       builder: (context, snapshot) {
//                         return Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Text(
//                               'Active Calories',
//                               style: TextStyle(
//                                 color: Colors.grey[600],
//                                 fontSize: 20.sp,
//                               ),
//                             ),
//                             Text(
//                               '${snapshot.data} kcal',
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 13.sp,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         );
//                       }),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget bottomTitleWidgets(double value, TitleMeta meta) {
//     List<String> times = [];
//     final now = DateTime.now();
//     String day = '${(now.month).toString()}-${(now.day + 7).toString()}';
//     for (int i = 0; i < date.length; i++) {
//       times.add(date[i]);
//     }

//     const style = TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 7,
//     );
//     Widget text = Text(day);
//     if (date.length == 0) {
//       switch (value.toInt()) {
//         default:
//           text = Text('${(now.month).toString()}-${(now.day + 7).toString()}',
//               style: style);
//           break;
//       }
//     } else if (date.isNotEmpty) {
//       for (int i = 0; i < date.length; i++) {
//         text = Text(date[i].substring(5, 10), style: style);
//       }
//     }
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       child: text,
//     );
//   }

//   Widget bottomTitleStepWidgets(double value, TitleMeta meta) {
//     final now = DateTime.now();
//     String day = '${(now.month).toString()}-${(now.day + 7).toString()}';

//     const style = TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 7,
//     );
//     Widget text = Text(day);
//     if (stepsDate.length == 0) {
//       switch (value.toInt()) {
//         default:
//           text = Text('${(now.month).toString()}-${(now.day + 7).toString()}',
//               style: style);
//           break;
//       }
//     } else if (stepsDate.isNotEmpty) {
//       for (int i = 0; i < stepsDate.length; i++) {
//         text = Text(stepsDate[i].substring(5, 10), style: style);
//       }
//       print(text);
//     }
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       child: text,
//     );
//   }

//   Widget leftTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 11,
//     );
//     String text;
//     switch (value.toInt()) {
//       case 50:
//         text = '50KG';
//         break;
//       case 70:
//         text = '70KG';
//         break;
//       case 90:
//         text = '90KG';
//         break;
//       case 100:
//         text = '100KG';
//         break;

//       default:
//         return Container();
//     }

//     return Text(text, style: style, textAlign: TextAlign.left);
//   }

//   Widget leftTitleStepWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 11,
//     );
//     String text;
//     switch (value.toInt()) {
//       case 0:
//         text = '0';
//         break;
//       case 3000:
//         text = '3000';
//         break;
//       case 5000:
//         text = '5000';
//         break;
//       case 7000:
//         text = '7000';
//         break;
//       case 10000:
//         text = '10000';
//         break;
//       case 14000:
//         text = '14000';
//         break;
//       case 18000:
//         text = '18000';
//         break;

//       default:
//         return Container();
//     }

//     return Text(text, style: style, textAlign: TextAlign.left);
//   }

//   LineChartData weightData() {
//     return LineChartData(
//       gridData: FlGridData(
//         show: true,
//         drawVerticalLine: true,
//         horizontalInterval: 1,
//         verticalInterval: 1,
//         getDrawingHorizontalLine: (value) {
//           return FlLine(
//             color: gradientColors[1],
//             strokeWidth: 1,
//           );
//         },
//         getDrawingVerticalLine: (value) {
//           return FlLine(
//             color: gradientColors[1],
//             strokeWidth: 1,
//           );
//         },
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         rightTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         topTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 30,
//             interval: 1,
//             getTitlesWidget: bottomTitleWidgets,
//           ),
//         ),
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             interval: 1,
//             getTitlesWidget: leftTitleWidgets,
//             reservedSize: 42,
//           ),
//         ),
//       ),
//       borderData: FlBorderData(
//         show: true,
//         border: Border.all(color: const Color(0xff37434d)),
//       ),
//       minX: 0,
//       maxX: date.length.toDouble(),
//       minY: 40,
//       maxY: 130,
//       lineBarsData: [
//         LineChartBarData(
//           spots: weightFl,
//           isCurved: true,
//           gradient: LinearGradient(
//             colors: gradientColors,
//           ),
//           barWidth: 5,
//           isStrokeCapRound: true,
//           dotData: FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors: gradientColors
//                   .map((color) => color.withOpacity(0.3))
//                   .toList(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   LineChartData stepData() {
//     return LineChartData(
//       gridData: FlGridData(
//         show: true,
//         drawVerticalLine: false,
//         horizontalInterval: 1,
//         verticalInterval: 1,
//         getDrawingHorizontalLine: (value) {
//           return FlLine(
//             color: gradientColors[1],
//             strokeWidth: 0.001,
//           );
//         },
//         getDrawingVerticalLine: (value) {
//           return FlLine(
//             color: gradientColors[1],
//             strokeWidth: 0.001,
//           );
//         },
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         rightTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         topTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 30,
//             interval: 1,
//             getTitlesWidget: bottomTitleStepWidgets,
//           ),
//         ),
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             interval: 1,
//             getTitlesWidget: leftTitleStepWidgets,
//             reservedSize: 42,
//           ),
//         ),
//       ),
//       borderData: FlBorderData(
//         show: true,
//         border: Border.all(color: Color.fromARGB(255, 180, 194, 205)),
//       ),
//       minX: 0,
//       maxX: date.length.toDouble(),
//       minY: 0,
//       maxY: 19000,
//       lineBarsData: [
//         LineChartBarData(
//           spots: stepsFl,
//           isCurved: true,
//           gradient: LinearGradient(
//             colors: gradientColors,
//           ),
//           barWidth: 5,
//           isStrokeCapRound: true,
//           dotData: FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors: gradientColors
//                   .map((color) => color.withOpacity(0.3))
//                   .toList(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }