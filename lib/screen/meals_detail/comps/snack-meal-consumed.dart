import 'package:Dietic/config/theme/fitness_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Dietic/config/config.dart';
import 'package:Dietic/model/model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../model/diet_plan_model.dart';
import '../../../service/diet_plan/diet_plan_service.dart';

class SnackMealConsumed extends StatefulWidget {
  const SnackMealConsumed({Key? key}) : super(key: key);

  @override
  State<SnackMealConsumed> createState() => _SnackMealConsumedState();
}

class _SnackMealConsumedState extends State<SnackMealConsumed> {
  List<FoodConsumed> consumedFoods = [];
  DietPlanService service = DietPlanService();
  List<DietPlanModel> snackFoods = [];
  List<int?> kcal = [];
  List<bool> isSelected = [];
  List<DietPlanModel> selectedFoods = [];
  double sumEnergy = 0;

  @override
  void initState() {
    DateTime date = DateTime.now();
    String time = date.toString().substring(0, 10);
    service.getSnackDietPlan().then((value) {
      snackFoods = value;
      isSelected = List<bool>.generate(snackFoods.length, (index) => false);
      setState(() {
        for (int i = 0; i < snackFoods.length; i++) {
          sumEnergy += snackFoods[i].energy!;
          if (snackFoods[i].eaten!.contains('UNCHECKED')) {
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
                        icon: Container(
                          decoration: BoxDecoration(
                            color: FitnessAppTheme.nearlyBlue,
                            shape: BoxShape.circle
                          ),
                          child: FaIcon(FontAwesomeIcons.check)),
                        onPressed: () {
                          for (int i = 0; i < snackFoods.length; i++) {
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
                child: snackFoods.isNotEmpty
                    ? ListView.builder(
                        itemCount: snackFoods.length,
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
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                '${snackFoods[index].foodName}',
                                            style: TextStyle(
                                                color: AppColors.colorTint700,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                              text:
                                                  ' x(${snackFoods[index].portion})',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12)),
                                          TextSpan(
                                            text:
                                                '\nDescription: ${snackFoods[index].details}',
                                            style: TextStyle(
                                              color: AppColors.colorTint600,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '\n${snackFoods[index].energy} kcal',
                                            style: TextStyle(
                                              color: AppColors.colorTint500,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                
                                ])),
                          );
                        },
                      )
                    : Text('There is no snack today')),
          ],
        ),
      ),
    );
  }

  void _updateSelectedItems(bool value, int index) {
    setState(() {
      isSelected[index] = value;
      selectedFoods.add(snackFoods[index]);
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
