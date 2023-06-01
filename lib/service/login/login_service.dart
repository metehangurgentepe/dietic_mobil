import 'package:dio/dio.dart';
import '../../model/login_model.dart';

class LoginService {
  final String baseUrl = "http://dietic.eu-north-1.elasticbeanstalk.com/api/auth/login";
  final dio = Dio();
  Future<LoginModel?> loginCall(
      {required String email, required String password}) async {
    try {
      Map<String, dynamic> json = {"email": email, "password": password};
      var response = await dio.post(baseUrl, data: json);
      if (response.statusCode == 200) {
        Options(
          validateStatus: (_) => true,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        );
        var result = LoginModel.fromJson(response.data);
        return result;
      } else {
        print('there is no login call status code');
      }
    } on DioError catch (e) {
      print(e);
    }
    return null;
  }
}
