import 'package:dio/dio.dart';
import '../../model/login_model.dart';


class LoginService {
  final String baseUrl = "http://192.168.1.103:8080/api/v1/auth/authenticate";
  final dio = Dio();
  Future<LoginModel?> loginCall(
      {required String email, required String password}) async {

    try{
      Map<String, dynamic> json = {"email": email, "password": password};
      var response = await dio.post(baseUrl,data: json);
      print('status code burda');
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('burası logincall');
        Options (
          validateStatus: (_) => true,
          contentType: Headers.jsonContentType,
          responseType:ResponseType.json,
        );
        var result = LoginModel.fromJson(response.data);
        print(response.data.toString());
        return result;
      }
    else{
      print('login call status code yok');
    }
      }
    on DioError catch(e){
     /* if (e.response!.statusCode == 200) {
        Options (
          validateStatus: (_) => true,
          contentType: Headers.jsonContentType,
          responseType:ResponseType.json,
        );
        var result = LoginModel.fromJson(e.response!.data);
        print(e.response!.data.toString());
        return result;
      }
      else{
        print(e.response!.data);
      }*/
    }
    return null;
  }
}
