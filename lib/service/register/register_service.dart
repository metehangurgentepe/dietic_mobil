
import 'package:dio/dio.dart';
import 'package:Dietic/model/register_model.dart';

class SignUpService {
  final String baseUrl = "http://192.168.1.103:8080/api/v1/auth/register";
  final dio = Dio();
  Future<RegisterModel?> signUpCall(
      {required String firstName,required String lastName,required String email, required String password}) async {
    try{
      Map<String, dynamic> json = {"firstName":firstName,"lastName":lastName,"email": email, "password": password};
      var response = await dio.post(baseUrl, data: json);
      if (response.statusCode == 200) {
        var result = RegisterModel.fromJson(response.data);
        return result;
      } else {
        throw ("Bir sorun oluştu ${response.statusCode}");
      }
    }
    on DioError catch(e){
     /* if (e.response!.statusCode == 200) {
        Options (
          validateStatus: (_) => true,
          contentType: Headers.jsonContentType,
          responseType:ResponseType.json,
        );
        var result = RegisterModel.fromJson(e.response!.data);
        print(e.response!.data.toString());
        return result;
      }
      else{
        print(e.response!.data);

      }*/

    }

  }
}
