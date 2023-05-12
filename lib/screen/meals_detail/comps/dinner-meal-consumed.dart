import 'package:dietic_mobil/model/diet_plan_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dietic_mobil/config/config.dart';
import 'package:dietic_mobil/model/model.dart';

import '../../../service/diet_plan/diet_plan_service.dart';

class DinnerMealConsumed extends StatefulWidget {
  const DinnerMealConsumed({Key? key}) : super(key: key);

  @override
  State<DinnerMealConsumed> createState() => _DinnerMealConsumedState();
}

class _DinnerMealConsumedState extends State<DinnerMealConsumed> {
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
    service.getDinnerDietPlan(time).then((value) {
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
                        sumEnergy.toInt().toString(),
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
                      IconButton(
                        icon: Icon(Icons.save),
                        onPressed: () {
                          for (int i = 0; i < dinnerPlan.length; i++) {
                            service.checkedEaten(selectedFoods[i]);
                          }
                        },
                      )
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
                            onChanged: (value) {
                              setState(() {
                                _updateSelectedItems(value!, index);
                              });
                            },
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
                                '${dinnerPlan[index].foodName} x(${dinnerPlan[index].portion}) ' ?? '',
                                style: TextStyle(
                                    color: AppColors.colorTint700,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5.w),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Visibility(
                                    visible: dinnerPlan[index].details!.trim().isNotEmpty,
                                    child: Text(
                                      'Description: ${dinnerPlan[index].details!}',
                                      style: TextStyle(
                                        color: AppColors.colorTint600,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),

                                  Text(
                                    '${dinnerPlan[index].energy!.toInt()} kcal' ??
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
              ):Text("Don't have dinner today")
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
