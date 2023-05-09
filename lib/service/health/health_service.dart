import 'dart:convert';

import 'package:dietic_mobil/model/health_model.dart';
import 'package:health/health.dart';

class HealthService{
  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);


  Future<List<HealthDataPoint>>? weekSteps;
  var water;
  final List<HealthDataPoint> healthDataPoints=[];

  Future<List<HealthDataPoint>> fetchWeekStepData() async {
    var permissions = [
      HealthDataAccess.READ,
    ];

    int? steps;
    int? todaySteps;
    var result;
    List<HealthDataPoint>? stepsList;
    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final month = DateTime.now().subtract(Duration(days: 30));
    bool requested = await health.requestAuthorization([HealthDataType.STEPS],permissions: permissions);

    if (requested) {
      try {
        weekSteps=health.getHealthDataFromTypes(month, now, [HealthDataType.STEPS]);
        print('week step');
        print(weekSteps!.then((value) => print(value.first)));
        
        weekSteps!.then((List<HealthDataPoint> data){
          stepsList=data;
          });
          
        //jsonDecode(jsonData) as List<dynamic>
        print("*****************");
        
        print(steps);

        return stepsList!;
      } catch (error) {
        return throw Exception('$error');
      }

     


    } else {
      return throw Exception();
    }
  }
  
  Future fetchTodayStepData() async {
    int? todaySteps;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final week = DateTime(now.year, now.month,now.day-7);

    bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

    if (requested) {
      try {
        DateTime midnight=DateTime(now.year,now.month,now.day);
        todaySteps = await health.getTotalStepsInInterval(midnight, now);
        return todaySteps.toString();
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }

      print('Total number of steps: $todaySteps');


    } else {
      print("Authorization not granted - error in authorization");
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
  Future<HealthModel?> fetchWaterData() async {
    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    bool requested = await health.requestAuthorization([HealthDataType.WATER],permissions: [HealthDataAccess.READ]);

    if (requested) {
      try {
        DateTime midnight=DateTime(now.year,now.month,now.day);
        water = await health.getHealthDataFromTypes(midnight, now,[HealthDataType.WATER]);
        print("su");
        print(water);
        print(jsonEncode(water));

        return HealthModel.fromJson(water);
      } catch (error) {
        return throw("Caught exception in getTotalStepsInInterval: $error");
      }
      print('Total number of water: $water');


    } else {
      return throw("Authorization not granted - error in authorization");
    }
  }
  

}