import 'package:Dietic/model/steps_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../model/weight_model.dart';

class StepService {
  FlutterSecureStorage storage = FlutterSecureStorage();

  List<StepsModel> steps = [];
  Future<List<StepsModel>> getAllSteps() async {
    String? patientId = await storage.read(key: 'patientId');
    String url =
        'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/dietitians/patients/${patientId}/getAllSteps';

    Dio dio = Dio();
    String? token = await storage.read(key: 'token');
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      var response = await dio.post(url);
      for (int i = 0; i < response.data.length; i++) {
        steps.add(StepsModel.fromJson(response.data[i]));
      }
      print(steps);
      return steps;
    } catch (e) {
      throw Exception('${e} steps detail alınamadı');
    }
  }

  Future saveSteps(int steps) async {
    DateTime now = DateTime.now();
    String date = now.toString().substring(0, 10);
    String? patientId = await storage.read(key: 'patientId');
    String url =
        'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/dietitians/patients/${patientId}/saveSteps';

    Dio dio = Dio();
    String? token = await storage.read(key: 'token');
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    Map<String, dynamic> data = {'date': '${date}', 'steps': steps};

    try {
      var response = await dio.post(url, data: data);

      return response;
    } catch (e) {
      throw Exception('${e} steps detail alınamadı');
    }
  }
}
