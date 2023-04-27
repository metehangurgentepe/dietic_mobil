import 'dart:convert';
import 'dart:core';

import 'package:dietic_mobil/model/diet_plan_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class DietPlanService {
  List<dynamic> foodItems = [];
  List<DietPlanModel> results = [];
  final storage = FlutterSecureStorage();
  final String baseUrl =
      'http://localhost:8080/api/v1/dietPlans/patient/3/day/1';
  final dio = Dio();

  var jsonResponse;

  List<String?> foodNamesBreakfast = [];
  List<String?> foodNamesLunch = [];
  List<String?> foodNamesDinner = [];
  late DietPlanModel foodNamesFirstDay;
  late DietPlanModel breakfastPlan;
  late DietPlanModel lunchPlan;
  late DietPlanModel dinnerPlan;
  late DietPlanModel snackPlan;
  List<DietPlanModel> lunchList = [];
  List<DietPlanModel> breakfastList = [];
  List<DietPlanModel> dinnerList = [];
  List<DietPlanModel> snackList = [];
  List<DietPlanModel> lunchListPlan = [];
  List<DietPlanModel> breakfastListPlan = [];
  List<DietPlanModel> dinnerListPlan = [];
  List<DietPlanModel> snackListPlan = [];

  List<int?> energies = [];

  List<int> breakfastEnergy = [];
  List<int> lunchEnergy = [];
  List<int> dinnerEnergy = [];
  List<int> snackEnergy = [];

  List<DietPlanModel> FirstDayFoods = [];

  //get breakfast data
  Future<List<DietPlanModel>> getFirstDietPlan() async {
    String? dieticianId = await storage.read(key: 'dieticianId');
    String? patientId = await storage.read(key: 'patientId');
    String Url = 'http://10.0.2.2:8080/api/v1/dietPlans/patient/3/day/1';

    final result = await http.get(
      Uri.parse(baseUrl),
    );
    try {
      if (result.statusCode == 200) {
        jsonResponse = jsonDecode(result.body);
        //yemekleri öğüne göre listeye ekleme
        for (int i = 0; i < jsonResponse.length; i++) {
          foodNamesFirstDay = DietPlanModel.fromJson(jsonResponse[i]);
          FirstDayFoods.add(foodNamesFirstDay);
        }
        return FirstDayFoods;
      } else {
        print('api error');
      }
    } catch (e) {
      print('error: $e');
    }
    return throw Exception('hata diet plan first day servis');
  }

  Future<List<DietPlanModel>> getBreakfastDietPlan() async {
    String? dieticianId = await storage.read(key: 'dieticianId');
    String? patientId = await storage.read(key: 'patientId');
    print(baseUrl);
    final String Url =
        'http://10.0.2.2:8080/api/v1/dietPlans/patient/3/day/1/meal/1';

    final result = await http.get(
      Uri.parse(baseUrl + '/meal/1'),
    );
    try {
      if (result.statusCode == 200) {
        jsonResponse = jsonDecode(result.body);
        foodItems = jsonDecode(result.body);
        print(foodItems.length);
        //yemekleri öğüne göre listeye ekleme
        for (int i = 0; i < foodItems.length; i++) {
          breakfastPlan = DietPlanModel.fromJson(jsonResponse[i]);
          breakfastList.add(breakfastPlan);
          print('aw12');
        }
        print(breakfastList);

        return breakfastList;
      } else {
        print('api error');
      }
    } catch (e) {
      print('error: $e');
    }
    return throw Exception('hata diet plan breakfast servis');
  }

  Future<List<int?>> getFirstDietPlanEnergy() async {
    String? dieticianId = await storage.read(key: 'dieticianId');
    String? patientId = await storage.read(key: 'patientId');
    print(baseUrl);
    final String Url = 'http://10.0.2.2:8080/api/v1/dietPlans/patient/3/day/1';

    final result = await http.get(
      Uri.parse(baseUrl),
    );
    try {
      if (result.statusCode == 200) {
        jsonResponse = jsonDecode(result.body);
        print('uzunlugu');
        print(jsonResponse.length);
        foodItems = jsonDecode(result.body);
        int total1 = 0;
        int total2 = 0;
        int total3 = 0;
        int total4 = 0;

        print(foodItems.length);
        for (int i = 0; i < jsonResponse.length; i++) {
          if (DietPlanModel.fromJson(jsonResponse[i]).meal == 1) {
            breakfastEnergy
                .add(DietPlanModel.fromJson(jsonResponse[i]).energy!);
            total1 = breakfastEnergy.reduce((a, b) => a + b);
          } else if (DietPlanModel.fromJson(jsonResponse[i]).meal == 2) {
            lunchEnergy.add(DietPlanModel.fromJson(jsonResponse[i]).energy!);
            total2 = lunchEnergy.reduce((a, b) => a + b);
          } else if (DietPlanModel.fromJson(jsonResponse[i]).meal == 3) {
            dinnerEnergy.add(DietPlanModel.fromJson(jsonResponse[i]).energy!);
            total3 = dinnerEnergy.reduce((a, b) => a + b);
          } else if (DietPlanModel.fromJson(jsonResponse[i]).meal == 4) {
            snackEnergy.add(DietPlanModel.fromJson(jsonResponse[i]).energy!);
            total4 = snackEnergy.reduce((a, b) => a + b);
          }
        }
        energies = [total1, total2, total3, total4];
        return energies;
      } else {
        print('api error');
      }
    } catch (e) {
      print('error: $e');
    }
    return throw Exception('hata diet plan energy servis');
  }

  Future<List<DietPlanModel>> getLunchDietPlan() async {
    String? dieticianId = await storage.read(key: 'dieticianId');
    String? patientId = await storage.read(key: 'patientId');
    print(baseUrl);
    final String Url =
        'http://10.0.2.2:8080/api/v1/dietPlans/patient/3/day/1/meal/2';

    final result = await http.get(
      Uri.parse(baseUrl + '/meal/2'),
    );
    try {
      if (result.statusCode == 200) {
        jsonResponse = jsonDecode(result.body);
        foodItems = jsonDecode(result.body);
        print(foodItems.length);
        //yemekleri öğüne göre listeye ekleme
        for (int i = 0; i < foodItems.length; i++) {
          lunchPlan = DietPlanModel.fromJson(jsonResponse[i]);
          lunchList.add(lunchPlan);
          print(lunchPlan);
        }
        return lunchList;
      } else {
        print('api error');
      }
    } catch (e) {
      print('error: $e');
    }
    return throw Exception('hata diet plan breakfast servis');
  }

  Future<List<DietPlanModel>> getDinnerDietPlan() async {
    String? dieticianId = await storage.read(key: 'dieticianId');
    String? patientId = await storage.read(key: 'patientId');
    print(baseUrl);
    final String Url =
        'http://10.0.2.2:8080/api/v1/dietPlans/patient/3/day/1/meal/3';

    final result = await http.get(
      Uri.parse(baseUrl + '/meal/3'),
    );
    try {
      if (result.statusCode == 200) {
        jsonResponse = jsonDecode(result.body);
        foodItems = jsonDecode(result.body);
        print(foodItems.length);
        //yemekleri öğüne göre listeye ekleme
        for (int i = 0; i < foodItems.length; i++) {
          dinnerPlan = DietPlanModel.fromJson(jsonResponse[i]);
          dinnerList.add(dinnerPlan);
        }
        return dinnerList;
      } else {
        print('api error');
      }
    } on Exception catch (e) {
      print('error: $e');
    }
    return throw Exception('hata diet plan breakfast servis');
  }

  Future<List<DietPlanModel>> getSnackDietPlan() async {
    String? dieticianId = await storage.read(key: 'dieticianId');
    String? patientId = await storage.read(key: 'patientId');
    print(baseUrl);
    final String Url =
        'http://10.0.2.2:8080/api/v1/dietPlans/patient/3/day/1/meal/4';

    final result = await http.get(
      Uri.parse(baseUrl + '/meal/4'),
    );
    try {
      if (result.statusCode == 200) {
        jsonResponse = jsonDecode(result.body);
        foodItems = jsonDecode(result.body);
        print(foodItems.length);
        //yemekleri öğüne göre listeye ekleme
        for (int i = 0; i < foodItems.length; i++) {
          snackPlan = DietPlanModel.fromJson(jsonResponse[i]);
          snackList.add(snackPlan);
        }
        return snackList;
      } else {
        print('api error');
      }
    } on Exception catch (e) {
      print('error: $e');
    }
    return throw Exception('hata diet plan breakfast servis');
  }
}
