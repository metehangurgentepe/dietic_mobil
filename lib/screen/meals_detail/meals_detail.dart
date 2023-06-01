import 'package:Dietic/dietician-screen/home/widget/meal-consumed.dart';
import 'package:Dietic/screen/meals_detail/comps/daily-summary.dart';
import 'package:Dietic/screen/meals_detail/comps/out_record_meal.dart';
import 'package:Dietic/service/diet_plan/dyt_plan_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grock/grock.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../config/theme/theme.dart';
import '../../model/diet_plan_model.dart';
import '../../service/diet_plan/diet_plan_service.dart';
import '../../widget/meal-consumed-tile.dart';
import 'comps/breakfast-meal-consumed.dart';
import 'comps/dinner-meal-consumed.dart';
import 'comps/lunchs-meal-consumed.dart';
import 'comps/snack-meal-consumed.dart';
import 'package:getwidget/getwidget.dart';

class MealsDetailScreen extends StatefulWidget {
  static const String routeName = '/meals_detail';

  const MealsDetailScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => const MealsDetailScreen(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<MealsDetailScreen> createState() => _MealsDetailScreenState();
}

class _MealsDetailScreenState extends State<MealsDetailScreen> {
  final service = DietPlanService();
  List<DietPlanModel> dietPlan = [];
  double carbonhydrate = 0;
  double protein = 0;
  double energy = 0;
  double fats = 0;

  double eatenEnergy = 0;
  double eatenCarbs = 0;
  double eatenFats = 0;
  double eatenProteins = 0;
  @override
  void initState() {
    print('yalnız');
    service.getFirstDietPlan().then((value) {
      setState(() {
        dietPlan = value;
        print('buralar');
        print(dietPlan);
        for (int i = 0; i < dietPlan.length; i++) {
          carbonhydrate += dietPlan[i].carb ?? 0;
          protein += dietPlan[i].protein!;
          energy += dietPlan[i].energy!;
          fats += dietPlan[i].fat!;
          print(carbonhydrate);
          print('buraburaburabura**********************');

          if (dietPlan[i].eaten == 'CHECKED') {
            eatenCarbs += dietPlan[i].carb ?? 0;
            eatenProteins += dietPlan[i].protein!;
            eatenEnergy += dietPlan[i].energy!;
            eatenFats += dietPlan[i].fat!;
          }
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushNamed(context, '/fitness-home');
            },
          ),
          title: Text('Diet Plan Detail'),
          backgroundColor: AppColors.colorAccent,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: Container(
                child: Column(
                  children: [
                    DailySummaryPatient(),
                    BreakfastMealConsumed(),
                    LunchMealConsumed(),
                    DinnerMealConsumed(),
                    SnackMealConsumed(),
                    OutOfRecordMealConsumed(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget DailySummaryPatient() {
    return AspectRatio(
      aspectRatio: 1.6,
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: AppColors.colorAccent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_circleProgress(), _macronutrients()],
        ),
      ),
    );
  }

  Widget _circleProgress() {
    return SizedBox(
      width: 160.w,
      height: 160.w,
      child: Stack(
        children: [
          SizedBox(
            width: 160.w,
            height: 160.w,
            child: CircularProgressIndicator(
              strokeWidth: 8.w,
              value: 0.7,
              backgroundColor: AppColors.colorTint100.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
                    color: AppColors.colorTint100.withOpacity(0.2), width: 8.w),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.colorTint100.withOpacity(0.1),
                ),
                child: Container(
                  margin: EdgeInsets.all(22.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Remaining',
                        style: TextStyle(
                          color: AppColors.colorTint300,
                          fontSize: 10.sp,
                        ),
                      ),
                      fats == 0
                          ? Text(
                              '0',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
                              '${(energy - eatenEnergy).toLimitedStringWithComma(1)}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                      Text(
                        'kcal',
                        style: TextStyle(
                          color: AppColors.colorTint300,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _macronutrients() {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      _macronutrientsTile(
          title: 'Carbs',
          percentValue: carbonhydrate == 0 ? eatenCarbs / carbonhydrate : 0.1,
          amountInGram: carbonhydrate != 0
              ? '${eatenCarbs.toInt()}/${carbonhydrate.toInt()}g'
              : '0'),
      _macronutrientsTile(
          title: 'Proteins',
          percentValue: protein == 0 ? eatenProteins / protein : 0.1,
          amountInGram: protein != 0
              ? '${eatenProteins.toInt()}/${protein.toInt()}g'
              : '0'),
      _macronutrientsTile(
          title: 'Fats',
          percentValue: fats == 0 ? eatenFats / fats : 0.1,
          amountInGram:
              fats != 0 ? '${eatenFats.toInt()}/${fats.toInt()}g' : '0')
    ]);
  }

  Widget _macronutrientsTile(
      {String? title, double? percentValue, String? amountInGram}) {
    return SizedBox(
      height: 50.w,
      width: 120.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title!,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
          LinearPercentIndicator(
            width: 120.w,
            animation: true,
            lineHeight: 6,
            animationDuration: 2500,
            percent: percentValue!.isNaN ? 0.01 : percentValue,
            barRadius: Radius.circular(3),
            progressColor: Colors.white,
            padding: EdgeInsets.zero,
            backgroundColor: AppColors.colorTint100.withOpacity(0.2),
          ),
          Text(
            amountInGram!,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
