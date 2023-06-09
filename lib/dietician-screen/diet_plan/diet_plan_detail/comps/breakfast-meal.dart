import 'package:Dietic/model/diet_plan_model.dart';
import 'package:Dietic/service/diet_plan/diet_plan_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Dietic/config/config.dart';
import 'package:Dietic/model/model.dart';

class BreakfastMeal extends StatefulWidget {
  const BreakfastMeal({Key? key, required this.patientId, required this.time})
      : super(key: key);
  final int patientId;
  final String time;
  @override
  State<BreakfastMeal> createState() => _BreakfastMealState();
}

class _BreakfastMealState extends State<BreakfastMeal> {
  List<FoodConsumed> consumedFoods = [];
  DietPlanService service = DietPlanService();
  List<DietPlanModel> breakfastFoods = [];
  List<int?> kcal = [];
  List<bool> isSelected = [];
  List<DietPlanModel> selectedFoods = [];

  var value;
  DateTime now = DateTime.now();

  double sumEnergy = 0;

  @override
  void initState() {
    service.BreakfastDietPlan(widget.time, widget.patientId).then((value) {
      breakfastFoods = value;
      print(breakfastFoods);
      print(widget.time);
      isSelected = List<bool>.generate(breakfastFoods.length, (index) => false);
      setState(() {
        print(widget.time);
        for (int i = 0; i < breakfastFoods.length; i++) {
          sumEnergy += breakfastFoods[i].energy!;
          if (breakfastFoods[i].eaten!.contains('UNCHECKED')) {
            isSelected[i] = false;
          } else {
            isSelected[i] = true;
          }
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
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
                        '${sumEnergy.toString()}',
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
                child: breakfastFoods.isNotEmpty
                    ? ListView.builder(
                        itemCount: breakfastFoods.length,
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
                                              '${breakfastFoods[index].foodName} (x${breakfastFoods[index].portion!.toStringAsFixed(0)})'),
                                          SizedBox(height: 5.w),
                                          Text(
                                            '${breakfastFoods[index].energy} kcal',
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

  void _updateSelectedItems(bool value, int index) {
    setState(() {
      isSelected[index] = value;
      selectedFoods.add(breakfastFoods[index]);
      if (value) {
        for (int i = 0; i < selectedFoods.length; i++) {
          selectedFoods[i].eaten = 'CHECKED';
        }
        print(selectedFoods[2].foodName);
      } else {
        for (int i = 0; i < selectedFoods.length; i++) {
          selectedFoods[i].eaten = 'UNCHECKED';
        }
      }
    });
  }
}
