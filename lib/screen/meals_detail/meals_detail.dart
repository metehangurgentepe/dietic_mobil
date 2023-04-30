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
                    BreakfastMealConsumed(),
                    LunchMealConsumed(),
                    DinnerMealConsumed(),
                    SnackMealConsumed(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
  }
 

