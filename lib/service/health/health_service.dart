import 'dart:convert';

import 'package:dietic_mobil/model/health_model.dart';
import 'package:health/health.dart';

class HealthService{
  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);


  Future<List<HealthDataPoint>>? weekSteps;
  var water;
  final List<HealthDataPoint> healthDataPoints=[];

  Future<HealthModel> fetchWeekStepData() async {
    var permissions = [
      HealthDataAccess.READ,
    ];

    int? steps;
    int? todaySteps;
    var result;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final week = DateTime(now.year, now.month,now.day-7);

    bool requested = await health.requestAuthorization([HealthDataType.STEPS],permissions: permissions);

    if (requested) {
      try {
        steps = await health.getTotalStepsInInterval(week, now);
        todaySteps = await health.getTotalStepsInInterval(week, now);
        weekSteps=health.getHealthDataFromTypes(week, now, [HealthDataType.STEPS]);
        print(weekSteps);
        print(healthDataPoints);
        weekSteps!.then((List<HealthDataPoint> data){
          result = jsonEncode(data);
          print("json encode");

          print(jsonEncode(data));
        });
        //jsonDecode(jsonData) as List<dynamic>
        print("*****************");




        return HealthModel.fromJson(result);
      } catch (error) {
        return throw Exception('$error');
      }

      print('Total number of steps: $steps');


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