import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../model/diet_plan_model.dart';
import 'package:http/http.dart' as http;


class PlanService {
  List<DietPlanModel> foodItems = [];
  final storage = FlutterSecureStorage();
  final String baseUrl = 'http://10.0.2.2:8080/api/v1/dietPlans/3/3';
  final dio = Dio();
  List listResponse=[];

  late List<DietPlanModel> jsonResponse;
  late List<DietPlanModel> myList;

  Future<List<dynamic>> getFirstDietPlan() async {
    String? dieticianId = await storage.read(key: 'dieticianId');
    String? patientId = await storage.read(key: 'patientId');
    final String Url = 'http://10.0.2.2:8080/api/v1/dietPlans/patient/3/day/1';

    final result = await http.get(
      Uri.parse(Url),
    );
    try {
      print(result.statusCode);
      if (result.statusCode == 200) {
        var jsonBody=DietPlanModel.fromJson(jsonDecode(result.body));
        listResponse=jsonDecode(result.body);
        for(int i=0;i<listResponse.length;i++){
          myList.add(listResponse[i]);
        }
       
        return myList;
      }
    }
    catch (err){
      return throw Exception(err.toString());
    }
    return throw Exception('giremedik');
  }
}