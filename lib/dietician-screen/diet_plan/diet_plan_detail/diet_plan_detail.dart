import 'package:dietic_mobil/model/patient_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/theme.dart';
import '../../../model/diet_plan_model.dart';
import '../../../service/diet_plan/diet_plan_service.dart';

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

  DietPlanService service = DietPlanService();
  List<DietPlanModel> breakfastFoods = [];
  List<DietPlanModel> lunchFoods = [];
  List<DietPlanModel> dinnerPlan = [];
  List<DietPlanModel> snackFoods = [];

  List<bool> isSelectedBreakfast = [];
  List<bool> isSelectedLunch = [];
  List<bool> isSelectedDinner = [];
  List<bool> isSelectedSnack = [];
  double sumBreakfastEnergy = 0;
  double sumLunchEnergy = 0;
  double sumDinnerEnergy = 0;
  double sumSnackEnergy = 0;

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
                      _selectDate(context);
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
                        print(timeNotifier);
                        service.BreakfastDietPlan(
                                timeNotifier.value!, widget.patients.patientId!)
                            .then((value) {
                          setState(() {
                            breakfastFoods = value;
                          });
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
                        service.DinnerDietPlan(
                                timeNotifier.value!, widget.patients.patientId!)
                            .then((value) {
                          snackFoods = value;
                        });
                        return SnackMeal(snackFoods);
                      }),
                ],
              ),
            ),
          ),
        ));
  }

  Widget BreakfastMeal(List<DietPlanModel> breakfastFoods) {
    List<DietPlanModel> breakfastPlan = this.breakfastFoods;
    List<bool> isSelected =
        List<bool>.generate(breakfastPlan.length, (index) => false);
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
    lunchPlan = lunchFoods;
    List<bool> isSelected =
        List<bool>.generate(lunchPlan.length, (index) => false);

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
    dinnerPlan = DinnerFoods;
    List<bool> isSelected =
        List<bool>.generate(dinnerPlan.length, (index) => false);

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
    snackPlan = snackFoods;
    List<bool> isSelected =
        List<bool>.generate(snackPlan.length, (index) => false);
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
}
