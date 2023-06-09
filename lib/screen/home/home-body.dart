import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widget/appbar.dart';
import 'widget/daily-calorie-statistics.dart';
import '../meals_detail/comps/daily-summary.dart';
import '../meals_detail/comps/breakfast-meal-consumed.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeBody extends StatelessWidget {

  const HomeBody({
    Key ? key
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(right: 15. w, left: 15. w),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: const [
            HomeScreenAppBar(),
            DailySummary(),
            DailyCalorieStatistics(),
          ],
        ),
      ),
    );
  }
}