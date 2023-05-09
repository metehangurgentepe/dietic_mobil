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

  List<double?> energies = [];

  List<double> breakfastEnergy = [];
  List<double> lunchEnergy = [];
  List<double> dinnerEnergy = [];
  List<double> snackEnergy = [];

  List<DietPlanModel> FirstDayFoods = [];
  List<DietPlanModel> SortedFoods = [];

  //get breakfast data
  Future<List<DietPlanModel>> getFirstDietPlan() async {
    String? dieticianId = await storage.read(key: 'dieticianId');
    String? patientId = await storage.read(key: 'patientId');
    String Url = 'http://localhost:8080/api/v1/dietPlans/patient/3/day/1';

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
          int j = 1;

          SortedFoods.add(FirstDayFoods[i]);
        }

        return SortedFoods;
      } else {
        print('api error');
      }
    } catch (e) {
      print('error: $e');
    }
    return throw Exception('hata diet plan first day servis');
  }

  Future<List<DietPlanModel>> getBreakfastDietPlan(String time) async {
    String? dieticianId = await storage.read(key: 'dieticianId');
    String? patientId = await storage.read(key: 'patientId');

    final String Url =
        'http://localhost:8080/api/v1/dietPlans/patient/${patientId}/meal/1';

    final result = await http.post(Uri.parse(baseUrl), body: {"day": time});
    try {
      if (result.statusCode == 200) {
        jsonResponse = jsonDecode(result.body);
        foodItems = jsonDecode(result.body);

        //yemekleri öğüne göre listeye ekleme
        for (int i = 0; i < foodItems.length; i++) {
          breakfastPlan = DietPlanModel.fromJson(jsonResponse[i]);
          breakfastList.add(breakfastPlan);
        }
        return breakfastList;
      } else {
        print('api error');
      }
    } catch (e) {
      print('error: $e');
    }
    return throw Exception('hata diet plan breakfast servis');
  }

  // diyetisyen patient kahvaltı diet plan datasını çekerken kullanacağı service
  Future<List<DietPlanModel>> BreakfastDietPlan(
      String time, int patientId) async {
    final dio = Dio();
    String? dieticianId = await storage.read(key: 'dieticianId');
    String? token = await storage.read(key: 'token');

    final String Url =
        'http://localhost:8080/api/v1/dietPlans/patient/${patientId}/meal/1';
    print('zaman');
    print(time);
    print(patientId);
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      final result = await dio.post(Url, data: {"day": "$time"});
      if (result.statusCode == 200) {
        print(result.data);

        //yemekleri öğüne göre listeye ekleme
        for (int i = 0; i < result.data.length; i++) {
          breakfastPlan = DietPlanModel.fromJson(result.data[i]);
          breakfastList.add(breakfastPlan);
        }
        print(breakfastList);

        return breakfastList;
      }
    } catch (e) {
      print('error: $e');
    }
    return throw Exception('kahvaltı dyt hata');
  }

  Future<List<DietPlanModel>> LunchDietPlan(String time, int patientId) async {
    String? dieticianId = await storage.read(key: 'dieticianId');
    String? token = await storage.read(key: 'token');

    final String Url =
        'http://localhost:8080/api/v1/dietPlans/patient/${patientId}/meal/2';
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final result = await dio.post(Url, data: {"day": "$time"});
    try {
      if (result.statusCode == 200) {
        //yemekleri öğüne göre listeye ekleme
        for (int i = 0; i < result.data.length; i++) {
          breakfastPlan = DietPlanModel.fromJson(result.data[i]);
          breakfastList.add(breakfastPlan);
        }
        return breakfastList;
      } else {
        print('api error');
      }
    } catch (e) {
      print('error: $e');
    }
    return throw Exception('hata diet plan breakfast servis');
  }

  Future<List<DietPlanModel>> DinnerDietPlan(String time, int patientId) async {
    String? dieticianId = await storage.read(key: 'dieticianId');
    String? token = await storage.read(key: 'token');

    final String Url =
        'http://localhost:8080/api/v1/dietPlans/patient/${patientId}/meal/3';
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final result = await dio.post(Url, data: {"day": "$time"});
    try {
      if (result.statusCode == 200) {
        //yemekleri öğüne göre listeye ekleme
        for (int i = 0; i < result.data.length; i++) {
          breakfastPlan = DietPlanModel.fromJson(result.data[i]);
          breakfastList.add(breakfastPlan);
        }
        return breakfastList;
      } else {
        print('api error');
      }
    } catch (e) {
      print('error: $e');
    }
    return throw Exception('hata diet plan breakfast servis');
  }



  //SNACK DİET PLAN FOR DİETİTİAN REVİEW

  Future<List<DietPlanModel>> SnackDietPlan(String time, int patientId) async {
    String? dieticianId = await storage.read(key: 'dieticianId');
    String? token = await storage.read(key: 'token');

    final String Url =
        'http://localhost:8080/api/v1/dietPlans/patient/${patientId}/meal/4';
         dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final result = await dio.post(Url, data: {"day": "$time"});
    try {
      if (result.statusCode == 200) {
        //yemekleri öğüne göre listeye ekleme
        for (int i = 0; i < result.data.length; i++) {
          breakfastPlan = DietPlanModel.fromJson(result.data[i]);
          breakfastList.add(breakfastPlan);
        }
        return breakfastList;
      } else {
        print('api error');
      }
    } catch (e) {
      print('error: $e');
    }
    return throw Exception('hata diet plan breakfast servis');
  }

  Future<List<double?>> getFirstDietPlanEnergy() async {
    String? dieticianId = await storage.read(key: 'dieticianId');
    String? patientId = await storage.read(key: 'patientId');

    final String Url = 'http://localhost:8080/api/v1/dietPlans/patient/3/day/1';

    final result = await http.get(
      Uri.parse(baseUrl),
    );
    try {
      if (result.statusCode == 200) {
        jsonResponse = jsonDecode(result.body);

        foodItems = jsonDecode(result.body);
        double total1 = 0;
        double total2 = 0;
        double total3 = 0;
        double total4 = 0;

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
    final String Url =
        'http://localhost:8080/api/v1/dietPlans/patient/3/day/1/meal/2';

    final result = await http.get(
      Uri.parse(baseUrl + '/meal/2'),
    );
    try {
      if (result.statusCode == 200) {
        jsonResponse = jsonDecode(result.body);
        foodItems = jsonDecode(result.body);
        //yemekleri öğüne göre listeye ekleme
        for (int i = 0; i < foodItems.length; i++) {
          lunchPlan = DietPlanModel.fromJson(jsonResponse[i]);
          lunchList.add(lunchPlan);
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

    final String Url =
        'http://localhost:8080/api/v1/dietPlans/patient/3/day/1/meal/3';

    final result = await http.get(
      Uri.parse(baseUrl + '/meal/3'),
    );
    try {
      if (result.statusCode == 200) {
        jsonResponse = jsonDecode(result.body);
        foodItems = jsonDecode(result.body);

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

    final String Url =
        'http://localhost:8080/api/v1/dietPlans/patient/3/day/1/meal/4';

    final result = await http.get(
      Uri.parse(baseUrl + '/meal/4'),
    );
    try {
      if (result.statusCode == 200) {
        jsonResponse = jsonDecode(result.body);
        foodItems = jsonDecode(result.body);

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

  Future checkedEaten(DietPlanModel dietPlanModel) async {
    Dio dio = Dio();
    String url =
        'http://localhost:8080/api/v1/dietPlans/updateEaten/${dietPlanModel.planId}';
    String? token = await storage.read(key: 'token');
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    Map<String, dynamic> data = {
      "plan_id": dietPlanModel.planId,
      "day": dietPlanModel.day,
      "meal": dietPlanModel.meal,
      "food_id": dietPlanModel.foodId,
      "food_name": dietPlanModel.foodName,
      "carb": dietPlanModel.carb,
      "protein": dietPlanModel.protein,
      "fat": dietPlanModel.fat,
      "energy": dietPlanModel.energy,
      "details": dietPlanModel.details,
      "eaten": dietPlanModel.eaten
    };
    try {
      var response = dio.patch(url, data: data);
      print(response.toString());
    } catch (e) {
      print(e);
    }
  }
}
