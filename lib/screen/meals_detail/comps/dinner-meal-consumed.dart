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
  List<DietPlanModel> lunchPlan = [];
  List<String?> lunchName = [];
  List<int?> kcal = [];
  int sumEnergy = 0;
  List<int> selectedKcal = [];

  bool isTicked = false;



  @override
  void initState() {
    service.getDinnerDietPlan().then((value) {
      setState(() {
        lunchPlan = value;
        for (int i = 0; i < lunchPlan.length; i++) {
          lunchName.add(lunchPlan[i].foodName);
          kcal.add(lunchPlan[i].energy);
          sumEnergy = kcal.fold(0, (a, b) => a + b!);
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
              child: ListView.builder(
                itemCount: lunchName.length,
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
                                lunchName[index] ?? '',
                                style: TextStyle(
                                    color: AppColors.colorTint700,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5.w),
                              Row(
                                children: [
                                  Text(
                                    '${kcal[index].toString()} kcal' ?? '',
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  void provideConsumedFoods() {
    consumedFoods.add(FoodConsumed(
      foodName: 'Espresso coffe',
      consumedAmount: '30 ml',
      boxColor: AppColors.colorTint200,
      icon: SvgPicture.asset('assets/icons/tea.svg', width: 25.w, height: 25.w),
    ));

    consumedFoods.add(FoodConsumed(
      foodName: 'Croissant',
      consumedAmount: '100 ml',
      boxColor: AppColors.colorErrorLight,
      icon: SvgPicture.asset('assets/icons/croissant.svg',
          width: 25.w, height: 25.w),
    ));
  }
}
