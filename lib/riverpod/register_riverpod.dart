import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grock/grock.dart';
import 'package:Dietic/screen/home/home.dart';
import 'package:Dietic/screen/login/login.dart';
import 'package:Dietic/screen/register/register.dart';
import '../components/loading_popup.dart';
import '../screen/home/home-body.dart';
import '../screen/nav/nav.dart';
import '../service/login/login_service.dart';
import '../service/login/login_service.dart';
import '../service/register/register_service.dart';

class RegisterRiverpod extends ChangeNotifier {
  final service = SignUpService();
  final storage = FlutterSecureStorage();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  final token ='';
  final emailString = '';
  final int id=0;

  void fetch() {
    service
        .signUpCall(email: email.text, password: password.text, firstName: firstName.text, lastName: lastName.text)
        .then((value) async {
      print('riverpod');
      print(value);
      print(value!.email);
      if(value != null){
        await storage.write(key: 'jwt', value: value!.token);
        await storage.write(key: 'username', value: value!.firstName);
        await storage.write(key: 'lastname', value: value!.lastName);
        await storage.write(key: 'email', value: value!.email);
        await storage.write(key: 'id' ,value: value!.id.toString());
        print('burası');
        Grock.snackBar(
          title: "Hesabınız oluşturulmuştur", description: 'Hesabınız oluşturulmuştur'
        );
        Grock.to(NavScreen());
      }
      if (value == null) {
        Grock.snackBar(
            title: "Hata",
            description: "Girilmiş olan kullanıcı verileriyle kayıt olamıyorsunuz, lütfen tekrar deneyin");
        Grock.to(SignUpScreen());
      }
      else {
        print('value null değil ama false geldi');

      }




    });
  }
}
