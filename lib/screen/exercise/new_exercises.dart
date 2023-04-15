import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../../config/theme/theme.dart';
import '../../dietician-screen/home/widget/appbar.dart';
class NewExercises extends StatefulWidget {
  const NewExercises({Key? key}) : super(key: key);

  @override
  State<NewExercises> createState() => _NewExercisesState();
}

class _NewExercisesState extends State<NewExercises> {
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
    Container(
        decoration: BoxDecoration(
            color: Colors.grey
        ),
        padding: const EdgeInsets.all(20.0),
        alignment: Alignment.center,
        width: 250.0,
        height: 250.0,
        child: Column(
          children: [
            IconButton(onPressed: (){},icon: Icon(Icons.add,color: Colors.black54,)),
            SfSparkLineChart(
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

            ),
          ],
        )),
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
      body:
      SafeArea(
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //app bar(date and calendar)
                HomeScreenAppBar(),
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
                                child: FutureBuilder(
                                    future: getMoveData(),
                                    builder: (context, snapshot) {
                                      return Column(
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
                                              Text(
                                                  '${snapshot.data!.isEmpty ? 0 : snapshot.data}')
                                            ],
                                          ),
                                          Text('Movement Time',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15)),
                                          Text('%30'),
                                          LinearPercentIndicator(
                                              barRadius: Radius.circular(20),
                                              width: 130,
                                              animation: true,
                                              animationDuration: 10000,
                                              lineHeight: 10,
                                              percent: 0.1,
                                              progressColor: Colors.amberAccent,
                                              backgroundColor: Color(0xfffaf1be))
                                        ],
                                      );
                                    }),
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
                                    future: getStepData(),
                                    builder: (context, snapshot) {
                                      /* double percent=double.parse(snapshot.data != null ? snapshot.data!  : '0')/10000;
                                      if(percent>=1){
                                        double percent=0.99;
                                      }
                                      else if(percent==null){
                                        double percent=0.1;
                                      }*/
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
                                              Text(
                                                  '${snapshot.data == 0 ? 0 : snapshot.data}')
                                            ],
                                          ),
                                          Text('Steps',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18)),
                                          Text('%30'),
                                          LinearPercentIndicator(
                                            barRadius: Radius.circular(20),
                                            width: 130,
                                            animation: true,
                                            animationDuration: 10000,
                                            lineHeight: 10,
                                            percent: 0.1,
                                            progressColor: Colors.pinkAccent,
                                            backgroundColor: Color(0xffE0A0B2),
                                          )
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
                CarouselSlider(
                  options: CarouselOptions(
                    height: 400.0,
                    enlargeCenterPage: true,
                    aspectRatio: 16/9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: false,
                    viewportFraction: 0.8,
                  ),
                  items: items,
                ),
                SizedBox(height: 25),
              ]

          ),
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
