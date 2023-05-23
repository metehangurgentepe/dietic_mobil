import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grock/grock.dart';

class ChangePasswordService {
  final storage = FlutterSecureStorage();
  String baseUrl =
      'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/users/change';

  Future passwordChange(String currentPass, String newPass) async {
    String? token = await storage.read(key: 'token');
    Dio dio = Dio();
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    Map<String, dynamic> data = {
      'currentPassword': currentPass,
      'newPassword': newPass
    };
    try {
      var response = await dio.post(baseUrl, data: data);
      Grock.snackBar(
            title: "Başarılı",
            description:
                "Şifreniz başarıyla değiştirilmiştir");
      print(response);
    } catch (e) {
      Grock.snackBar(
            title: "Hata",
            description:
                "Girilmiş olan kullanıcı verileri sistemdekiler ile eşleşmemektedir");
      print(e);

    }
  }
}
