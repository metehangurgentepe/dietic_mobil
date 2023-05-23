import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../model/weight_model.dart';
class WeightService {
  FlutterSecureStorage storage = FlutterSecureStorage();
  String url = 'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/dietitians/patients/progress';
  List<WeightModel> weight=[];
  Future<List<WeightModel>> getWeights() async {
    Dio dio = Dio();
    String? token = await storage.read(key: 'token');
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      var response = await dio.get(url);
      for(int i=0;i<response.data.length;i++){
        weight.add(WeightModel.fromJson(response.data[i]));
      }
      print(weight);
      return weight;
    } catch (e) {
      throw Exception('${e} patient detail alınamadı');
    }
  }
}
