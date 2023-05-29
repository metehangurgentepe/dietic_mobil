import 'dart:convert';

import 'package:Dietic/model/health_model.dart';
import 'package:health/health.dart';

class HealthService{
  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);


  Future<List<HealthDataPoint>>? weekSteps;
  var water;
  final List<HealthDataPoint> healthDataPoints=[];
  
  Future<int> fetchTodayStepData() async {
    int? todaySteps;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final week = DateTime(now.year, now.month,now.day-7);

    bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

    if (requested) {
      try {
        DateTime midnight=DateTime(now.year,now.month,now.day);
        todaySteps = await health.getTotalStepsInInterval(midnight, now);
        print('today steps');
        print(todaySteps);
        return todaySteps!;
      } catch (error) {
        return throw Exception("Caught exception in getTotalStepsInInterval: $error");
      }
    } else {
      return throw Exception("Authorization not granted - error in authorization");
    }
  }
  Future fetchEnergyData() async {
    int? energy;
    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final week = DateTime(now.year, now.month,now.day-7);

    bool requested = await health.requestAuthorization([HealthDataType.ACTIVE_ENERGY_BURNED]);

    if (requested) {
      try {
        DateTime midnight=DateTime(now.year,now.month,now.day);
        energy = await health.getTotalStepsInInterval(midnight, now);
        return energy.toString();
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }

      print('Total number of steps: $energy');


    } else {
      print("Authorization not granted - error in authorization");
    }
  }

}