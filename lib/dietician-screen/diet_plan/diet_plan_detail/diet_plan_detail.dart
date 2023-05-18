import 'package:dietic_mobil/dietician-screen/diet_plan/diet_plan_detail/comps/daily-summary.dart';
import 'package:dietic_mobil/model/patient_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grock/grock.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../config/theme/theme.dart';
import '../../../model/diet_plan_model.dart';
import '../../../service/diet_plan/diet_plan_service.dart';
import '../../../service/diet_plan/dyt_plan_service.dart';

class DietPlanDetail extends StatefulWidget {
  const DietPlanDetail({super.key, required this.patients});
  static const String routeName = '/diet-plan-detail';

  static Route route({required PatientModel patients}) {
    return MaterialPageRoute(
        builder: (_) => DietPlanDetail(
              patients: patients,
            ),
        settings: const RouteSettings(name: routeName));
  }

  final PatientModel patients;

  @override
  State<DietPlanDetail> createState() => _DietPlanDetailState();
}

class _DietPlanDetailState extends State<DietPlanDetail> {
  DateTime selectedDate = DateTime.now();

  final dytService = PlanService();
  DietPlanService service = DietPlanService();

  List<DietPlanModel> allFoods = [];
  List<DietPlanModel> breakfastFoods = [];
  List<DietPlanModel> lunchFoods = [];
  List<DietPlanModel> dinnerPlan = [];
  List<DietPlanModel> snackFoods = [];
  List<DietPlanModel> outOfRecordFoods = [];

  List<bool> isSelectedBreakfast = [];
  List<bool> isSelectedLunch = [];
  List<bool> isSelectedDinner = [];
  List<bool> isSelectedSnack = [];
  List<bool> isSelectedOutOfRecord = [];

 

 

  String? desiredTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    String? time;
    setState(() {
      time = selectedDate.toString().substring(0, 10);
      print(time);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String time = selectedDate.toString().substring(0, 10);

    ValueNotifier<String?> timeNotifier = ValueNotifier<String?>(time);
    desiredTime = timeNotifier.value!;

    return Scaffold(
        appBar: AppBar(
          title: Text('Diet Plan Detail'),
          backgroundColor: AppColors.colorAccent,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        timeNotifier;
                        _selectDate(context);
                      });
                      
                    },
                    icon: Icon(Icons.calendar_month),
                  ),
                  Text(selectedDate
                      .toString()
                      .substring(0, 10)
                      .replaceAll('-', '/')),
                  ValueListenableBuilder<String?>(
                      valueListenable: timeNotifier,
                      builder:
                          (BuildContext context, String? value, Widget? child) {
                        dytService
                            .getFirstDietPlanForDyt(
                                timeNotifier.value!, widget.patients.patientId!)
                            .then((value) {
                          allFoods = value;
                        });
                        return DailySummary(allFoods);
                      }),
                  ValueListenableBuilder<String?>(
                      valueListenable: timeNotifier,
                      builder:
                          (BuildContext context, String? value, Widget? child) {
                        print(timeNotifier);
                        service.BreakfastDietPlan(
                                timeNotifier.value!, widget.patients.patientId!)
                            .then((value) {
                          breakfastFoods = value;
                        });
                        return BreakfastMeal(breakfastFoods);
                      }),
                  ValueListenableBuilder<String?>(
                      valueListenable: timeNotifier,
                      builder:
                          (BuildContext context, String? value, Widget? child) {
                        print(timeNotifier);
                        service.LunchDietPlan(
                                timeNotifier.value!, widget.patients.patientId!)
                            .then((value) {
                          lunchFoods = value;
                        });
                        return LunchMeal(lunchFoods);
                      }),
                  ValueListenableBuilder<String?>(
                      valueListenable: timeNotifier,
                      builder:
                          (BuildContext context, String? value, Widget? child) {
                        print(timeNotifier);
                        service.DinnerDietPlan(
                                timeNotifier.value!, widget.patients.patientId!)
                            .then((value) {
                          dinnerPlan = value;
                        });
                        return DinnerMeal(dinnerPlan);
                      }),
                  ValueListenableBuilder<String?>(
                      valueListenable: timeNotifier,
                      builder:
                          (BuildContext context, String? value, Widget? child) {
                        print(timeNotifier);
                        service.SnackDietPlan(
                                timeNotifier.value!, widget.patients.patientId!)
                            .then((value) {
                          snackFoods = value;
                        });
                        return SnackMeal(snackFoods);
                      }),
                  ValueListenableBuilder<String?>(
                      valueListenable: timeNotifier,
                      builder:
                          (BuildContext context, String? value, Widget? child) {
                        print(timeNotifier);
                        service.OutOfRecordDietPlan(
                                timeNotifier.value!, widget.patients.patientId!)
                            .then((value) {
                          outOfRecordFoods = value;
                        });
                        return OutOfRecordMeal(outOfRecordFoods);
                      }),
                ],
              ),
            ),
          ),
        ));
  }

  Widget BreakfastMeal(List<DietPlanModel> breakfastFoods) {
    double sumBreakfastEnergy=0;
    List<bool> isSelected =
        List<bool>.generate(breakfastFoods.length, (index) => false);
    for (int i = 0; i < breakfastFoods.length; i++) {

          sumBreakfastEnergy += breakfastFoods[i].energy!;
          if (breakfastFoods[i].eaten!.contains('UNCHECKED')) {
            isSelected[i] = false;
          } else {
            isSelected[i] = true;
          }
        }
    List<DietPlanModel> breakfastPlan = this.breakfastFoods;
    
    print('plan burada');
    print(breakfastPlan);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: double.infinity,
      ),
      child: Container(
        margin: EdgeInsets.only(top: 30.w, bottom: 30.w),
        padding: EdgeInsets.only(left: 10.w),
        child: Column(
          children: [
            SizedBox(
              height: 40.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 25.w,
                        width: 25.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 4.w,
                          value: 0.7,
                          backgroundColor:
                              AppColors.colorAccent.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.colorWarning),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Text(
                        'Breakfast',
                        style: TextStyle(
                          color: AppColors.colorTint700,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${sumBreakfastEnergy.toString()}',
                        style: TextStyle(
                          color: AppColors.colorTint500,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'kcal',
                        style: TextStyle(
                          color: AppColors.colorTint500,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.w),
            Container(
                child: breakfastPlan.isNotEmpty
                    ? ListView.builder(
                        itemCount: breakfastPlan.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 70.w,
                            margin: EdgeInsets.zero,
                            child: IntrinsicHeight(
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                  Checkbox(
                                    value: isSelected[index],
                                    onChanged: null,
                                  ),
                                  VerticalDivider(
                                    color: AppColors.colorTint300,
                                    thickness: 2,
                                  ),
                                  SizedBox(width: 15.w),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              '${breakfastPlan[index].foodName} (x${breakfastPlan[index].portion!.toStringAsFixed(0)})'),
                                          SizedBox(height: 5.w),
                                          Text(
                                            '${breakfastPlan[index].energy} kcal',
                                            style: TextStyle(
                                              color: AppColors.colorTint500,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ])),
                          );
                        },
                      )
                    : Text('There is no breakfast for you :)')),
          ],
        ),
      ),
    );
  }

  Widget LunchMeal(List<DietPlanModel> lunchFoods) {
    List<DietPlanModel> lunchPlan;
    double sumLunchEnergy=0;
    lunchPlan = lunchFoods;
     List<bool> isSelected =
        List<bool>.generate(lunchPlan.length, (index) => false);
    
    for (int i = 0; i < lunchPlan.length; i++) {
          
          sumLunchEnergy += lunchPlan[i].energy!;
          if (lunchPlan[i].eaten!.contains('UNCHECKED')) {
            isSelected[i] = false;
          } else {
            isSelected[i] = true;
          }
        }
    
   

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: double.infinity,
      ),
      child: Container(
        margin: EdgeInsets.only(top: 30.w, bottom: 30.w),
        padding: EdgeInsets.only(left: 10.w),
        child: Column(
          children: [
            SizedBox(
              height: 40.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 25.w,
                        width: 25.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 4.w,
                          value: 0.7,
                          backgroundColor:
                              AppColors.colorAccent.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.colorWarning),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Text(
                        'Lunch',
                        style: TextStyle(
                          color: AppColors.colorTint700,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${sumLunchEnergy.toString()}',
                        style: TextStyle(
                          color: AppColors.colorTint500,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'kcal',
                        style: TextStyle(
                          color: AppColors.colorTint500,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.w),
            Container(
                child: lunchPlan.isNotEmpty
                    ? ListView.builder(
                        itemCount: lunchPlan.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 70.w,
                            margin: EdgeInsets.zero,
                            child: IntrinsicHeight(
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                  Checkbox(
                                    value: isSelected[index],
                                    onChanged: null,
                                  ),
                                  VerticalDivider(
                                    color: AppColors.colorTint300,
                                    thickness: 2,
                                  ),
                                  SizedBox(width: 15.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          '${lunchPlan[index].foodName} (x ${lunchPlan[index].portion!.toStringAsFixed(0)})'),
                                      SizedBox(height: 5.w),
                                      Text(
                                        '${lunchPlan[index].energy.toString()} kcal',
                                        style: TextStyle(
                                          color: AppColors.colorTint500,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ])),
                          );
                        },
                      )
                    : Text('There is no lunch for you :)')),
          ],
        ),
      ),
    );
  }

  Widget DinnerMeal(List<DietPlanModel> DinnerFoods) {
    List<DietPlanModel> dinnerPlan;
    double sumDinnerEnergy=0;
    dinnerPlan = DinnerFoods;
    List<bool> isSelected =
        List<bool>.generate(dinnerPlan.length, (index) => false);
         for (int i = 0; i < dinnerPlan.length; i++) {
          sumDinnerEnergy += dinnerPlan[i].energy!;
          if (dinnerPlan[i].eaten!.contains('UNCHECKED')) {
            isSelected[i] = false;
          } else {
            isSelected[i] = true;
          }
        }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: double.infinity,
      ),
      child: Container(
        margin: EdgeInsets.only(top: 30.w, bottom: 30.w),
        padding: EdgeInsets.only(left: 10.w),
        child: Column(
          children: [
            SizedBox(
              height: 40.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 25.w,
                        width: 25.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 4.w,
                          value: 0.7,
                          backgroundColor:
                              AppColors.colorAccent.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.colorWarning),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Text(
                        'Dinner',
                        style: TextStyle(
                          color: AppColors.colorTint700,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        sumDinnerEnergy.toString(),
                        style: TextStyle(
                          color: AppColors.colorTint500,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'kcal',
                        style: TextStyle(
                          color: AppColors.colorTint500,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.w),
            Container(
                child: dinnerPlan.isNotEmpty
                    ? ListView.builder(
                        itemCount: dinnerPlan.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 70.w,
                            margin: EdgeInsets.zero,
                            child: IntrinsicHeight(
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                  Checkbox(
                                    value: isSelected[index],
                                    onChanged: null,
                                  ),
                                  VerticalDivider(
                                    color: AppColors.colorTint300,
                                    thickness: 2,
                                  ),
                                  SizedBox(width: 15.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${dinnerPlan[index].foodName} (x ${dinnerPlan[index].portion!.toStringAsFixed(0)})',
                                        style: TextStyle(
                                            color: AppColors.colorTint700,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 5.w),
                                      Row(
                                        children: [
                                          Text(
                                            '${dinnerPlan[index].energy.toString()} kcal' ??
                                                '',
                                            style: TextStyle(
                                              color: AppColors.colorTint500,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ])),
                          );
                        },
                      )
                    : Text('There is no dinner for you :)')),
          ],
        ),
      ),
    );
  }

  Widget SnackMeal(List<DietPlanModel> snackFoods) {
    List<DietPlanModel> snackPlan;
    double sumSnackEnergy=0;
    snackPlan = snackFoods;
    List<bool> isSelected =
        List<bool>.generate(snackPlan.length, (index) => false);

           for (int i = 0; i < snackPlan.length; i++) {
          sumSnackEnergy += snackPlan[i].energy!;
          if (snackPlan[i].eaten!.contains('UNCHECKED')) {
            isSelected[i] = false;
          } else {
            isSelected[i] = true;
          }
        }
        
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: double.infinity,
      ),
      child: Container(
        margin: EdgeInsets.only(top: 30.w, bottom: 30.w),
        padding: EdgeInsets.only(left: 10.w),
        child: Column(
          children: [
            SizedBox(
              height: 40.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 25.w,
                        width: 25.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 4.w,
                          value: 0.7,
                          backgroundColor:
                              AppColors.colorAccent.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.colorWarning),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Text(
                        'Snack',
                        style: TextStyle(
                          color: AppColors.colorTint700,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        sumSnackEnergy.toString(),
                        style: TextStyle(
                          color: AppColors.colorTint500,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'kcal',
                        style: TextStyle(
                          color: AppColors.colorTint500,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.w),
            Container(
                child: snackPlan.isNotEmpty
                    ? ListView.builder(
                        itemCount: snackPlan.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 70.w,
                            margin: EdgeInsets.zero,
                            child: IntrinsicHeight(
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                  Checkbox(
                                      value: isSelected[index],
                                      onChanged: null),
                                  VerticalDivider(
                                    color: AppColors.colorTint300,
                                    thickness: 2,
                                  ),
                                  SizedBox(width: 15.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${snackPlan[index].foodName} (x ${snackPlan[index].portion!.toStringAsFixed(0)})',
                                        style: TextStyle(
                                            color: AppColors.colorTint700,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 5.w),
                                      Text(
                                        snackPlan[index].energy.toString(),
                                        style: TextStyle(
                                          color: AppColors.colorTint500,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  )
                                ])),
                          );
                        },
                      )
                    : Text('There is no snack foods for you :)')),
          ],
        ),
      ),
    );
  }

  Widget OutOfRecordMeal(List<DietPlanModel> outOfRecordFoods) {
    double sumoutOfRecordEnergy=0;

    List<DietPlanModel> outOfRecordPlan = this.outOfRecordFoods;
    List<bool> isSelectedOutOfRecord =
        List<bool>.generate(outOfRecordPlan.length, (index) => false);
           for (int i = 0; i < outOfRecordPlan.length; i++) {
          sumoutOfRecordEnergy += outOfRecordPlan[i].energy!;
          if (outOfRecordPlan[i].eaten!.contains('UNCHECKED')) {
            isSelectedOutOfRecord[i] = false;
          } else {
            isSelectedOutOfRecord[i] = true;
          }
        }
        
    print('plan burada');
    print(outOfRecordPlan);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: double.infinity,
      ),
      child: Container(
        margin: EdgeInsets.only(top: 30.w, bottom: 30.w),
        padding: EdgeInsets.only(left: 10.w),
        child: Column(
          children: [
            SizedBox(
              height: 40.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 25.w,
                        width: 25.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 4.w,
                          value: 0.7,
                          backgroundColor:
                              AppColors.colorAccent.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.colorWarning),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Text(
                        'Out Of Record',
                        style: TextStyle(
                          color: AppColors.colorTint700,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${sumoutOfRecordEnergy.toString()}',
                        style: TextStyle(
                          color: AppColors.colorTint500,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'kcal',
                        style: TextStyle(
                          color: AppColors.colorTint500,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.w),
            Container(
                child: outOfRecordPlan.isNotEmpty
                    ? ListView.builder(
                        itemCount: outOfRecordPlan.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 70.w,
                            margin: EdgeInsets.zero,
                            child: IntrinsicHeight(
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                  Checkbox(
                                    value: isSelectedOutOfRecord[index],
                                    onChanged: null,
                                  ),
                                  VerticalDivider(
                                    color: AppColors.colorTint300,
                                    thickness: 2,
                                  ),
                                  SizedBox(width: 15.w),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              '${outOfRecordPlan[index].foodName} (x${outOfRecordPlan[index].portion!.toStringAsFixed(0)})'),
                                          SizedBox(height: 5.w),
                                          Text(
                                            '${outOfRecordPlan[index].energy} kcal',
                                            style: TextStyle(
                                              color: AppColors.colorTint500,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ])),
                          );
                        },
                      )
                    : Text('You are perfect')),
          ],
        ),
      ),
    );
  }

  Widget DailySummary(List<DietPlanModel> allFoods) {
    List<DietPlanModel> allFoods = this.allFoods;
     double carbonhydrate=0;
  double protein = 0;
  double energy = 0;
  double fats = 0;

  double eatenEnergy = 0;
  double eatenCarbs = 0;
  double eatenFats = 0;
  double eatenProteins = 0;
 
    for (int i = 0; i < allFoods.length; i++) {
      carbonhydrate += allFoods[i].carb!;
      protein += allFoods[i].protein!;
      energy += allFoods[i].energy!;
      fats += allFoods[i].fat!;

      if (allFoods[i].eaten == 'CHECKED') {
        eatenCarbs += allFoods[i].carb!;
        eatenProteins += allFoods[i].protein!;
        eatenEnergy += allFoods[i].energy!;
        eatenFats += allFoods[i].fat!;
      }
    }
     allFoods.clear();
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
          children: [_circleProgress(energy,eatenEnergy), _macronutrients(carbonhydrate,protein,fats,eatenCarbs,eatenProteins,eatenFats)],
        ),
      ),
    );
  }

  Widget _circleProgress(double energy, double eatenEnergy) {
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
                      energy == 0
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

  Widget _macronutrients(double carbonhydrate, double protein, double fats, double eatenCarbs, double eatenProteins, double eatenFats) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      _macronutrientsTile(
          title: 'Carbs',
          percentValue: carbonhydrate != 0 ? eatenCarbs / carbonhydrate! : 0.1,
          amountInGram: eatenCarbs != 0
              ? '${eatenCarbs.toInt()}/${carbonhydrate!.toInt()}g'
              : '0/${carbonhydrate!.toLimitedStringWithComma(1)}'),
      _macronutrientsTile(
          title: 'Proteins',
          percentValue: protein != 0 ? eatenProteins / protein : 0.1,
          amountInGram: eatenProteins != 0
              ? '${eatenProteins.toInt()}/${protein.toInt()}g'
              : '0/${protein.toLimitedStringWithComma(1)}'),
      _macronutrientsTile(
          title: 'Fats',
          percentValue: fats != 0 ? eatenFats / fats : 0.1,
          amountInGram:
              eatenFats != 0 ? '${eatenFats.toInt()}/${fats.toInt()}g' : '0/${fats.toLimitedStringWithComma(1)}')
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
