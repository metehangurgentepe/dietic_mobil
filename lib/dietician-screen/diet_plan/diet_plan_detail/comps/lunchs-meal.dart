import 'package:dietic_mobil/model/diet_plan_model.dart';
import 'package:dietic_mobil/service/diet_plan/diet_plan_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dietic_mobil/config/config.dart';
import 'package:dietic_mobil/model/model.dart';

class LunchMeal extends StatefulWidget {
  const LunchMeal( {Key ? key, required this.patientId}): super(key: key);
  final int patientId;

  @override
  State < LunchMeal > createState() => _LunchMealState();
}

class _LunchMealState extends State < LunchMeal > {
  List < FoodConsumed > consumedFoods = [];
  DietPlanService service =DietPlanService();
  List<DietPlanModel> lunchFoods=[];
  List<String?> lunchName=[];
  List<int?> kcal=[];
  List<DietPlanModel> selectedFoods = [];


  var value;

  double sumEnergy=0;


  List<bool> isSelected=[];
  @override
  void initState() {
    DateTime date =DateTime.now();
    String time= date.toString().substring(0,10); 
    service.LunchDietPlan(time,widget.patientId).then((value){
      setState(() {
        lunchFoods=value;
        isSelected = List<bool>.generate(lunchFoods.length, (index) => false);
        for(int i=0;i<lunchFoods.length;i++){
          sumEnergy += lunchFoods[i].energy!;
           if (lunchFoods[i].eaten!.contains('UNCHECKED')) {
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
                        '${sumEnergy.toString()}',
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
              child: lunchFoods.isNotEmpty ? ListView.builder(
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
                              Text(
                                '${lunchFoods[index].foodName} (x ${lunchFoods[index].portion!.toStringAsFixed(0)})'),
                              SizedBox(height: 5. w),
                              Text(
                                '${lunchFoods[index].energy.toString()} kcal',
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
              ):Text('There is no lunch for you :)')
            ),
          ],
        ),
      ),
    );
  }
    void _updateSelectedItems(bool value, int index) {
    setState(() {
      isSelected[index] = value;
      selectedFoods.add(lunchFoods[index]);
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