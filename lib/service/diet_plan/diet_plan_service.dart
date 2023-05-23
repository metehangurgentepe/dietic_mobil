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
      'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/dietPlans/patient/3/day/1';
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
  late DietPlanModel outOfRecordPlan;
  List<DietPlanModel> lunchList = [];
  List<DietPlanModel> breakfastList = [];
  List<DietPlanModel> dinnerList = [];
  List<DietPlanModel> snackList = [];
  List<DietPlanModel> outOfRecordList = [];
  List<DietPlanModel> lunchListPlan = [];
  List<DietPlanModel> breakfastListPlan = [];
  List<DietPlanModel> dinnerListPlan = [];
  List<DietPlanModel> snackListPlan = [];
  List<DietPlanModel> outOfRecorListPlan = [];

  List<double?> energies = [];

  List<double> breakfastEnergy = [];
  List<double> lunchEnergy = [];
  List<double> dinnerEnergy = [];
  List<double> snackEnergy = [];
  List<double> outOfRecordEnergy = [];

  List<DietPlanModel> FirstDayFoods = [];
  List<DietPlanModel> SortedFoods = [];

  Future<List<DietPlanModel>> getFirstDietPlan() async {
    DateTime today = DateTime.now();
    String time = today.toString().substring(0, 10);

    String? patientId = await storage.read(key: 'patientId');
    String? token = await storage.read(key: 'token');

    String Url = 'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/dietPlans/patient/${patientId}';

    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      print(patientId);
      final result = await dio.post(Url, data: {"day": "$time"});
      if (result.statusCode == 200) {
        //yemekleri öğüne göre listeye ekleme
        for (int i = 0; i < result.data.length; i++) {
          foodNamesFirstDay = DietPlanModel.fromJson(result.data[i]);

          FirstDayFoods.add(foodNamesFirstDay);

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




 Future<List<DietPlanModel>> getFirstDietPlanForDyt(String time) async {
  

    String? patientId = await storage.read(key: 'patientId');
    String? token = await storage.read(key: 'token');

    String Url = 'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/dietPlans/patient/${patientId}';

    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      final result = await dio.post(Url, data: {"day": "$time"});
      if (result.statusCode == 200) {
        //yemekleri öğüne göre listeye ekleme
        for (int i = 0; i < result.data.length; i++) {
          foodNamesFirstDay = DietPlanModel.fromJson(result.data[i]);

          FirstDayFoods.add(foodNamesFirstDay);

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






  // diyetisyen patient kahvaltı diet plan datasını çekerken kullanacağı service
  Future<List<DietPlanModel>> BreakfastDietPlan(
      String time, int patientId) async {
    final dio = Dio();
    String? dieticianId = await storage.read(key: 'dieticianId');
    String? token = await storage.read(key: 'token');

    final String Url =
        'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/dietPlans/patient/${patientId}/meal/1';
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
        breakfastList.clear();

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
        'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/dietPlans/patient/${patientId}/meal/2';
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final result = await dio.post(Url, data: {"day": "$time"});
    try {
      if (result.statusCode == 200) {
        //yemekleri öğüne göre listeye ekleme
        lunchList.clear();
        for (int i = 0; i < result.data.length; i++) {
          lunchPlan = DietPlanModel.fromJson(result.data[i]);
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

  Future<List<DietPlanModel>> DinnerDietPlan(String time, int patientId) async {
    String? dieticianId = await storage.read(key: 'dieticianId');
    String? token = await storage.read(key: 'token');

    final String Url =
        'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/dietPlans/patient/${patientId}/meal/3';
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final result = await dio.post(Url, data: {"day": "$time"});
    try {
      if (result.statusCode == 200) {
        dinnerList.clear();
        //yemekleri öğüne göre listeye ekleme
        for (int i = 0; i < result.data.length; i++) {
          dinnerPlan = DietPlanModel.fromJson(result.data[i]);
          dinnerList.add(dinnerPlan);
        }
        return dinnerList;
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
        'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/dietPlans/patient/${patientId}/meal/4';
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final result = await dio.post(Url, data: {"day": "$time"});
    try {
      if (result.statusCode == 200) {
        snackList.clear();
        //yemekleri öğüne göre listeye ekleme
        for (int i = 0; i < result.data.length; i++) {
          snackPlan = DietPlanModel.fromJson(result.data[i]);
          snackList.add(snackPlan);
        }
        return snackList;
      } else {
        print('api error');
      }
    } catch (e) {
      print('error: $e');
    }
    return throw Exception('hata diet plan breakfast servis');
  }


  Future<List<DietPlanModel>> OutOfRecordDietPlan(String time, int patientId) async {
    String? dieticianId = await storage.read(key: 'dieticianId');
    String? token = await storage.read(key: 'token');

    final String Url =
        'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/dietPlans/patient/${patientId}/meal/5';
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final result = await dio.post(Url, data: {"day": "$time"});
    try {
      if (result.statusCode == 200) {
        outOfRecordList.clear();
        //yemekleri öğüne göre listeye ekleme
        for (int i = 0; i < result.data.length; i++) {
          outOfRecordPlan = DietPlanModel.fromJson(result.data[i]);
          outOfRecordList.add(outOfRecordPlan);
        }
        return outOfRecordList;
      } else {
        print('api error');
      }
    } catch (e) {
      print('error: $e');
    }
    return throw Exception('hata diet plan out of record servis');
  }

  Future<List<double?>> getFirstDietPlanEnergy() async {
    DateTime today = DateTime.now();
    String time = today.toString().substring(0, 10);
    String? patientId = await storage.read(key: 'patientId');
    String? token = await storage.read(key: 'token');

    final String Url =
        'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/dietPlans/patient/${patientId}';
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final result = await dio.post(Url, data: {"day": "$time"});
    try {
      if (result.statusCode == 200) {
        double total1 = 0;
        double total2 = 0;
        double total3 = 0;
        double total4 = 0;

        print(foodItems.length);
        for (int i = 0; i < result.data.length; i++) {
          if (DietPlanModel.fromJson(result.data[i]).meal == 1) {
            breakfastEnergy.add(DietPlanModel.fromJson(result.data[i]).energy!);
            total1 = breakfastEnergy.reduce((a, b) => a + b);
          } else if (DietPlanModel.fromJson(result.data[i]).meal == 2) {
            lunchEnergy.add(DietPlanModel.fromJson(result.data[i]).energy!);
            total2 = lunchEnergy.reduce((a, b) => a + b);
          } else if (DietPlanModel.fromJson(result.data[i]).meal == 3) {
            dinnerEnergy.add(DietPlanModel.fromJson(result.data[i]).energy!);
            total3 = dinnerEnergy.reduce((a, b) => a + b);
          } else if (DietPlanModel.fromJson(result.data[i]).meal == 4) {
            snackEnergy.add(DietPlanModel.fromJson(result.data[i]).energy!);
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

  //// PATIENT ANASAYFADAKİ APİLER
  Future<List<DietPlanModel>> getBreakfastDietPlan() async {
      DateTime today =DateTime.now();
    String time =today.toString().substring(0,10);
    String? patientId = await storage.read(key: 'patientId');
    String? token = await storage.read(key: 'token');
    print(patientId! + 'ssdfsdf');
    print('timing');
    print(time);
    final String Url =
        'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/dietPlans/patient/${patientId}/meal/1';
    print('zaman');
    print(time);
    print(patientId);
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      final result = await dio.post(Url, data: {"day": time});
      if (result.statusCode == 200) {
        print(result.data);
        breakfastList.clear();

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

  Future<List<DietPlanModel>> getLunchDietPlan() async {
     DateTime today =DateTime.now();
    String time =today.toString().substring(0,10);
    String? patientId = await storage.read(key: 'patientId');
    String? token = await storage.read(key: 'token');

    final String Url =
        'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/dietPlans/patient/${patientId}/meal/2';
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
        breakfastList.clear();

        //yemekleri öğüne göre listeye ekleme
        for (int i = 0; i < result.data.length; i++) {
          lunchPlan = DietPlanModel.fromJson(result.data[i]);
          lunchList.add(lunchPlan);
        }

        return lunchList;
      }
    } catch (e) {
      print('error: $e');
    }
    return throw Exception('kahvaltı dyt hata');
  }

  Future<List<DietPlanModel>> getDinnerDietPlan() async {
    DateTime today =DateTime.now();
    String time =today.toString().substring(0,10);
    String? dieticianId = await storage.read(key: 'dieticianId');
    String? patientId = await storage.read(key: 'patientId');

    String? token = await storage.read(key: 'token');

    final String Url =
        'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/dietPlans/patient/${patientId}/meal/3';
    print('zaman');
    print(patientId);
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      final result = await dio.post(Url, data: {"day": time});
      if (result.statusCode == 200) {
        print(result.data);
        dinnerList.clear();

        //yemekleri öğüne göre listeye ekleme
        for (int i = 0; i < result.data.length; i++) {
          dinnerPlan = DietPlanModel.fromJson(result.data[i]);
          dinnerList.add(dinnerPlan);
        }

        return dinnerList;
      }
    } catch (e) {
      print('error: $e');
    }
    return throw Exception('kahvaltı dyt hata');
  }

  Future<List<DietPlanModel>> getSnackDietPlan() async {
     DateTime today =DateTime.now();
    String time =today.toString().substring(0,10);
    String? dieticianId = await storage.read(key: 'dieticianId');
    String? patientId = await storage.read(key: 'patientId');

    String? token = await storage.read(key: 'token');

    final String Url =
        'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/dietPlans/patient/${patientId}/meal/4';
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
        breakfastList.clear();

        //yemekleri öğüne göre listeye ekleme
        for (int i = 0; i < result.data.length; i++) {
          snackPlan = DietPlanModel.fromJson(result.data[i]);
          snackList.add(snackPlan);
        }

        return snackList;
      }
    } catch (e) {
      print('error: $e');
    }
    return throw Exception('kahvaltı dyt hata');
  }
  Future<List<DietPlanModel>> getOutOfRecordDietPlan() async {
     DateTime today =DateTime.now();
    String time =today.toString().substring(0,10);
    String? dieticianId = await storage.read(key: 'dieticianId');
    String? patientId = await storage.read(key: 'patientId');

    String? token = await storage.read(key: 'token');

    final String Url =
        'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/dietPlans/patient/${patientId}/meal/5';
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
        
        //yemekleri öğüne göre listeye ekleme
        for (int i = 0; i < result.data.length; i++) {
          outOfRecordPlan = DietPlanModel.fromJson(result.data[i]);
          outOfRecordList.add(outOfRecordPlan);
        }

        return outOfRecordList;
      }
    } catch (e) {
      print('error: $e');
    }
    return throw Exception('kahvaltı dyt hata');
  }

  Future postDietPlan(int foodId, double portion,String details) async {
    String? dietId = await storage.read(key: 'dietitianId');
    String? patientId = await storage.read(key: 'patientId');
    DateTime now =DateTime.now();
    String time=now.toString().substring(0,10);
    String url =
        'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/dietPlans/${dietId}/${patientId}';
    String? token = await storage.read(key: 'token');
    print(url);
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    portion ?? 1;
    Map<String, dynamic> data = {
      "day": time,
      "meal": 5,
      "food_id": foodId,
      "details": details,
      "eaten": 'CHECKED',
      "portion":portion
    };
    try {
      var response = dio.post(url, data: data);
      print(response.toString());
    } catch (e) {
      print(e);
    }
  }

  Future checkedEaten(DietPlanModel dietPlanModel) async {
    Dio dio = Dio();
    String url =
        'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/dietPlans/updateEaten/${dietPlanModel.planId}';
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
