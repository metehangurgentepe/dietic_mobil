import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../config/theme/theme.dart';
import '../home/widget/appbar.dart';
import '../home/widget/daily-calorie-statistics.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({Key? key}) : super(key: key);
  static const String routeName = '/exercise';

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => ExerciseScreen(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  DateTime _selectedTime = DateTime.now();

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime(2025))
        .then((value) => {
              setState(() {
                _selectedTime = value!;
              })
            });
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    getMoveData();
    getStepData();
    getEnergyData();
  }

  final storage = new FlutterSecureStorage();

  Future<String?> getMoveData() async {
    String? move_mins = await storage.read(key: 'move_min');
    return move_mins;
  }

  Future<String?> getStepData() async {
    String? steps = await storage.read(key: 'steps');
    return steps;
  }

  Future<String?> getEnergyData() async {
    String? energy = await storage.read(key: 'energy');
    return energy;
  }
  final List<Widget> items = [
    Column(
      children: [
        Container(
            decoration: BoxDecoration(
                color: Colors.grey
            ),
            padding: const EdgeInsets.all(20.0),
            alignment: Alignment.center,
            width: 250.0,
            height: 250.0,
            child: SfSparkLineChart(
              // enable the trackball
                trackball: SparkChartTrackball(
                  activationMode: SparkChartActivationMode.tap,
                ),
                // enable marker
                marker: SparkChartMarker(
                  displayMode: SparkChartMarkerDisplayMode.all,
                ),
                // enable data label
                labelDisplayMode: SparkChartLabelDisplayMode.all,
                // use different data for each chart
                data: <double>[
                  92, 89, 85, 84, 83, 82,
                ]

            )),
      ],
    ),
    Container(
        decoration: BoxDecoration(
            color: Colors.grey
        ),
        padding: const EdgeInsets.all(20.0),
        alignment: Alignment.center,
        width: 250.0,
        height: 250.0,
        child: SfSparkLineChart(
          // enable the trackball
            trackball: SparkChartTrackball(
              activationMode: SparkChartActivationMode.tap,
            ),
            // enable marker
            marker: SparkChartMarker(
              displayMode: SparkChartMarkerDisplayMode.all,
            ),
            // enable data label
            labelDisplayMode: SparkChartLabelDisplayMode.all,
            // use different data for each chart
            data: <double>[
              1, 5, -6, 0, 1, -2,
            ]

        )
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Two Scrollable Widgets'),
      ),
      body: Column(
        children: <Widget>[
          CarouselSlider(
            options: CarouselOptions(
              height: 400.0,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16/9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              viewportFraction: 0.8,
            ),
            items: items,
          ),

          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  height: 200.0,
                  color: Colors.red,
                ),
                Container(
                  height: 200.0,
                  color: Colors.blue,
                ),
                Container(
                  height: 200.0,
                  color: Colors.green,
                ),
              ],
            ),
          ),
          Container(
            height: 200.0,
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(9, (index) {
                return Container(
                  color: Colors.grey,
                  margin: EdgeInsets.all(5.0),
                  child: Center(
                    child: Text(
                      'Grid Item $index',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
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
                      future: getEnergyData(),
                      builder: (context, snapshot) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Active Calories',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 10.sp,
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
}

