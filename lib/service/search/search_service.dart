import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../model/search_model.dart';

class SearchService {
  var data = [];
  List<SearchModel> results = [];
  final storage = FlutterSecureStorage();
  final String baseUrl = 'http://10.0.2.2:8080/api/v1/foods/search?query=';
  final dio = Dio();

  Future<List<SearchModel>>searchCall() async {
    String? value = await storage.read(key: 'searchWord');
    String? token = await storage.read(key: 'jwt');
    print(token);
    print(baseUrl + '$value');

      final result = await http.get(
        Uri.parse(baseUrl + '$value'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      print(result);
    try {
      if (result.statusCode == 200) {
        data = jsonDecode(result.body);
        results = data.map((e) => SearchModel.fromJson(e)).toList();
        print(results.first.description.toString());
      } else {
         print('api error');
      }
    } on Exception catch (e) {
      print('error: $e');
    }
    return results;
  }
}
