import 'package:dietic_mobil/model/patient_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../config/theme/theme.dart';
import '../../../service/diet_plan/diet_plan_service.dart';
import 'comps/breakfast-meal.dart';
import 'comps/dinner-meal.dart';
import 'comps/lunchs-meal.dart';
import 'comps/snack-meal.dart';

class DietPlanDetail extends StatefulWidget {
  const DietPlanDetail({super.key,required this.patients});
  static const String routeName = '/diet-plan-detail';
  


  static Route route({required PatientModel patients}) {
    return MaterialPageRoute(
        builder: (_) => DietPlanDetail(patients: patients,),
        settings: const RouteSettings(name: routeName));
  }
  final PatientModel patients;

  @override
  State<DietPlanDetail> createState() => _DietPlanDetailState();
}

class _DietPlanDetailState extends State<DietPlanDetail> {
 
    
  
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
                    BreakfastMeal(patientId: widget.patients.patientId!,),
                    LunchMeal(patientId: widget.patients.patientId!,),
                    DinnerMeal(patientId: widget.patients.patientId!,),
                    SnackMeal(patientId: widget.patients.patientId!,),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}