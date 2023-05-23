import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../model/user_model.dart';

class UpdateProfilePic{
  FlutterSecureStorage storage = FlutterSecureStorage();
  String baseUrl = 'http://dietic.eu-north-1.elasticbeanstalk.com/api/v1/users/';
  
  Future postProfilePic(String pictureUrl) async {
    Dio dio = Dio();
    String? token = await storage.read(key: 'token');
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    String url='${baseUrl}updatePicture';
    try {
      var response = await dio.put(url,data:{"picture":pictureUrl} );
      print('update profile pic');
      print(response.statusCode);
    } catch (e) {
      throw Exception('${e} patient detail alınamadı');
    }
  }
  
    Future<UserModel?> getProfilePic() async {
    Dio dio = Dio();
    String? token = await storage.read(key: 'token');
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    String url = '${baseUrl}getPicture';
    try {
      var response = await dio.get(url);
      UserModel user=UserModel.fromJson(response.data);
      print(user.name);
      print('userrrr');
      return user;
      
      
    } catch (e) {
      return throw Exception(e);
    }
  }


}