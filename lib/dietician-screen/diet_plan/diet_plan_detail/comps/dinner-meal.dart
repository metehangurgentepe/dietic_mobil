import 'package:Dietic/model/diet_plan_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Dietic/config/config.dart';
import 'package:Dietic/model/model.dart';

import '../../../../service/diet_plan/diet_plan_service.dart';

class DinnerMeal extends StatefulWidget {
  const DinnerMeal({Key? key,required this.patientId, required  this.time}) : super(key: key);
  final int patientId;
  final String time;
  @override
  State<DinnerMeal> createState() => _DinnerMealState();
}

class _DinnerMealState extends State<DinnerMeal> {
  List<FoodConsumed> consumedFoods = [];
  DietPlanService service = DietPlanService();
  List<DietPlanModel> dinnerPlan = [];
  double sumEnergy = 0;
  List<int> selectedKcal = [];
  List<bool> isSelected = [];
  List<DietPlanModel> selectedFoods = [];

  bool isTicked = false;

  @override
  void initState() {
    DateTime date =DateTime.now();
    String time= date.toString().substring(0,10); 
    service.DinnerDietPlan(widget.time,widget.patientId).then((value) {
      setState(() {
        dinnerPlan = value;
        isSelected = List<bool>.generate(dinnerPlan.length, (index) => false);
        for (int i = 0; i < dinnerPlan.length; i++) {
          sumEnergy += dinnerPlan[i].energy!;
          if (dinnerPlan[i].eaten!.contains('UNCHECKED')) {
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
                        sumEnergy.toString(),
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
              child: dinnerPlan.isNotEmpty ? ListView.builder(
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
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
              ):Text('There is no dinner for you :)')
            ),
          ],
        ),
      ),
    );
  }

  void _updateSelectedItems(bool value, int index) {
    setState(() {
      isSelected[index] = value;
      selectedFoods.add(dinnerPlan[index]);
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
