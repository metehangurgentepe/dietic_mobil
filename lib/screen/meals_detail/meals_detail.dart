import 'package:dietic_mobil/dietician-screen/home/widget/meal-consumed.dart';
import 'package:dietic_mobil/service/diet_plan/plan_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/theme.dart';
import '../../model/diet_plan_model.dart';
import '../../service/diet_plan/diet_plan_service.dart';
import '../../widget/meal-consumed-tile.dart';
import 'comps/breakfast-meal-consumed.dart';
import 'comps/dinner-meal-consumed.dart';
import 'comps/header.dart';
import 'comps/lunchs-meal-consumed.dart';
import 'comps/snack-meal-consumed.dart';

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
  final service=DietPlanService();
  List<DietPlanModel> breakfastFoodName=[];
  List<String?> breakfastName=[];
  List<int?> kcalBreakfast=[];
  List<DietPlanModel> breakfastFoods=[];
  List<int?> kcal=[];
  List<bool> isSelected=[];
  List<DietPlanModel> selectedFoods = [];
  List<DietPlanModel> lunchFoods=[];
  List<String?> lunchName=[];
  List<int?> lunchKcal=[];
  List<DietPlanModel> dinnerFoods=[];
  List<DietPlanModel> snackFoods=[];
  List<String?> dinnerName=[];
  List<int?> dinnerKcal=[];
  int sumEnergyBreakfast=0;
  int sumEnergyLunch=0;
  int sumEnergyDinner=0;
  int sumEnergySnack=0;
  List<DietPlanModel> sumAllFoods=[];
  List<DietPlanModel> foods=[];
  @override
  void initState() {
     service.getFirstDietPlan().then((value){
       foods=value;
       setState(() {
         isSelected = List<bool>.generate(foods.length, (index) => false);
      });
    //   print('sırası');
    //   print(foods);
       for(int i =0;i<foods.length;i++){
         print('name');
         print(foods[i].foodName);
       }
     });
    service.getBreakfastDietPlan().then((value){
      setState(() {
        breakfastFoods=value;
        for(int i=0;i<breakfastFoods.length;i++){
          sumAllFoods.add(breakfastFoods[i]);
          breakfastName.add(breakfastFoods[i].foodName);
          kcal.add(breakfastFoods[i].energy);
          sumEnergyBreakfast = kcal.fold(0, (a, b) => a + b!);
        }
      });
    });
    service.getLunchDietPlan().then((value) {
      setState(() {
        lunchFoods = value;
        for (int i = 0; i < lunchFoods.length; i++) {
          sumAllFoods.add(lunchFoods[i]);
          lunchName.add(lunchFoods[i].foodName);
          lunchKcal.add(lunchFoods[i].energy);
          sumEnergyLunch = lunchKcal.fold(0, (a, b) => a + b!);
        }
      });
    });
      service.getDinnerDietPlan().then((value) {
        setState(() {
          dinnerFoods = value;
          for (int i = 0; i < dinnerFoods.length; i++) {
            sumAllFoods.add(dinnerFoods[i]);
            lunchName.add(dinnerFoods[i].foodName);
            kcal.add(dinnerFoods[i].energy);
            sumEnergyDinner = kcal.fold(0, (a, b) => a + b!);
          }
        });
      });
      service.getSnackDietPlan().then((value) {
        setState(() {
          snackFoods = value;
          for (int i = 0; i < snackFoods.length; i++) {
            sumAllFoods.add(snackFoods[i]);
            kcal.add(snackFoods[i].energy);
            sumEnergySnack = kcal.fold(0, (a, b) => a + b!);
          }
        });

      });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diet Plan Detail'),
        backgroundColor: AppColors.colorAccent,
      ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 10),
              child: Container(
                child: Column(
                  children: [
                    BreakfastMeal(),
                    LunchMeal(),
                    DinnerMeal(),
                    SnackMeal(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
 Widget BreakfastMeal() {
   return ConstrainedBox(
     constraints: BoxConstraints(
       maxHeight: double.infinity,
     ),
     child: Container(
       margin: EdgeInsets.only(top: 30. w, bottom: 30. w),
       padding: EdgeInsets.only(left: 10. w),
       child: Column(
         children: [
           SizedBox(
             height: 40. w,
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Row(
                   children: [
                     SizedBox(
                       height: 25. w,
                       width: 25. w,
                       child: CircularProgressIndicator(
                         strokeWidth: 4. w,
                         value: 0.7,
                         backgroundColor: AppColors.colorAccent.withOpacity(0.2),
                         valueColor: AlwaysStoppedAnimation < Color > (AppColors.colorWarning),
                       ),
                     ),
                     SizedBox(width: 20. w),
                     Text(
                       'Breakfast',
                       style: TextStyle(
                         color: AppColors.colorTint700,
                         fontWeight: FontWeight.bold,
                         fontSize: 16. sp,
                       ),
                     ),
                   ],
                 ),
                 Row(
                   children: [
                     Text(
                       '${sumEnergyBreakfast.toString()}',
                       style: TextStyle(
                         color: AppColors.colorTint500,
                         fontWeight: FontWeight.bold,
                         fontSize: 16. sp,
                       ),
                     ),
                     SizedBox(width: 1. w),
                     Text(
                       'kcal',
                       style: TextStyle(
                         color: AppColors.colorTint500,
                         fontWeight: FontWeight.bold,
                         fontSize: 12. sp,
                       ),
                     ),
                   ],
                 ),
               ],
             ),
           ),
           SizedBox(height: 20. w),
           Container(
             child: ListView.builder(
               itemCount: breakfastFoods.length,
               scrollDirection: Axis.vertical,
               shrinkWrap: true,
               physics: NeverScrollableScrollPhysics(),
               padding: EdgeInsets.zero,
               itemBuilder: (BuildContext context, int index) {
                 return Container(
                   height: 70. w,
                   margin: EdgeInsets.zero,
                   child: IntrinsicHeight(
                       child: Row(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             Checkbox(
                               value: isSelected[index],
                               onChanged: (value) {
                                 setState(() {
                                   _updateSelectedItems(value!,index);
                                 });
                               },
                             ),
                             VerticalDivider(
                               color: AppColors.colorTint300,
                               thickness: 2,
                             ),
                             SizedBox(width: 15. w),
                             Row(
                               children: [
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Text('${breakfastName[index]}'),
                                     SizedBox(height: 5. w),
                                     Text(
                                       '${kcal[index].toString()} kcal',
                                       style: TextStyle(
                                         color: AppColors.colorTint500,
                                         fontWeight: FontWeight.bold,
                                         fontSize: 12. sp,
                                       ),
                                     ),
                                   ],
                                 ),
                               ],
                             ),

                           ]
                       )
                   ),
                 );
               },
             ),
           ),
         ],
       ),
     ),
   );
 }
  Widget LunchMeal() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: double.infinity,
      ),
      child: Container(
        margin: EdgeInsets.only(top: 30. w, bottom: 30. w),
        padding: EdgeInsets.only(left: 10. w),
        child: Column(
          children: [
            SizedBox(
              height: 40. w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 25. w,
                        width: 25. w,
                        child: CircularProgressIndicator(
                          strokeWidth: 4. w,
                          value: 0.7,
                          backgroundColor: AppColors.colorAccent.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation < Color > (AppColors.colorWarning),
                        ),
                      ),
                      SizedBox(width: 20. w),
                      Text(
                        'Lunch',
                        style: TextStyle(
                          color: AppColors.colorTint700,
                          fontWeight: FontWeight.bold,
                          fontSize: 16. sp,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${sumEnergyLunch.toString()}',
                        style: TextStyle(
                          color: AppColors.colorTint500,
                          fontWeight: FontWeight.bold,
                          fontSize: 16. sp,
                        ),
                      ),
                      SizedBox(width: 1. w),
                      Text(
                        'kcal',
                        style: TextStyle(
                          color: AppColors.colorTint500,
                          fontWeight: FontWeight.bold,
                          fontSize: 12. sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20. w),
            Container(
              child: ListView.builder(
                itemCount: lunchFoods.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 70. w,
                    margin: EdgeInsets.zero,
                    child: IntrinsicHeight(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: isSelected[index],
                                onChanged: (value) {
                                  setState(() {
                                    _updateSelectedItems(value!,index);
                                  });
                                },
                              ),
                              VerticalDivider(
                                color: AppColors.colorTint300,
                                thickness: 2,
                              ),
                              SizedBox(width: 15. w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('${lunchName[index]}'),
                                  SizedBox(height: 5. w),
                                  Text(
                                    '${lunchKcal[index].toString()} kcal',
                                    style: TextStyle(
                                      color: AppColors.colorTint500,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12. sp,
                                    ),
                                  ),
                                ],
                              ),
                            ]
                        )
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget DinnerMeal(){
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
                        sumEnergyDinner.toString(),
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
                itemCount: dinnerFoods.length,
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
                                    _updateSelectedItems(value!,index);
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
                                        '${dinnerFoods[index].energy.toString()} kcal' ?? '',
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
  Widget SnackMeal(){
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: double.infinity,
      ),
      child: Container(
        margin: EdgeInsets.only(top: 30. w, bottom: 30. w),
        padding: EdgeInsets.only(left: 10. w),
        child: Column(
          children: [
            SizedBox(
              height: 40. w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 25. w,
                        width: 25. w,
                        child: CircularProgressIndicator(
                          strokeWidth: 4. w,
                          value: 0.7,
                          backgroundColor: AppColors.colorAccent.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation < Color > (AppColors.colorWarning),
                        ),
                      ),
                      SizedBox(width: 20. w),
                      Text(
                        'Snack',
                        style: TextStyle(
                          color: AppColors.colorTint700,
                          fontWeight: FontWeight.bold,
                          fontSize: 16. sp,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        sumEnergySnack.toString(),
                        style: TextStyle(
                          color: AppColors.colorTint500,
                          fontWeight: FontWeight.bold,
                          fontSize: 16. sp,
                        ),
                      ),
                      SizedBox(width: 1. w),
                      Text(
                        'kcal',
                        style: TextStyle(
                          color: AppColors.colorTint500,
                          fontWeight: FontWeight.bold,
                          fontSize: 12. sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20. w),
            Container(
              child: ListView.builder(
                itemCount: snackFoods.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 70. w,
                    margin: EdgeInsets.zero,
                    child: IntrinsicHeight(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: isSelected[index],
                                onChanged: (value) {
                                  setState(() {
                                    _updateSelectedItems(value!,index);
                                  });
                                },
                              ),
                              VerticalDivider(
                                color: AppColors.colorTint300,
                                thickness: 2,
                              ),
                              SizedBox(width: 15. w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    snackFoods[index].foodName! ?? '',
                                    style: TextStyle(
                                        color: AppColors.colorTint700,
                                        fontSize: 15. sp,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  SizedBox(height: 5. w),
                                  Text(
                                    '${snackFoods[index].energy!.toString() ?? ''} kcal',
                                    style: TextStyle(
                                      color: AppColors.colorTint500,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12. sp,
                                    ),
                                  ),
                                ],
                              )
                            ]
                        )
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateSelectedItems(bool value, int index) {
    setState(() {
      isSelected[index] = value;
      if (value) {
        selectedFoods.add(foods[index]);
        print(selectedFoods[0].foodName);
      } else {
        selectedFoods.remove(foods[index]);
      }
    });
  }




}
