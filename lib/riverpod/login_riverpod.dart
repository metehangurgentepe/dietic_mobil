import 'package:dietic_mobil/dietician-screen/nav/nav_dietician.dart';
import 'package:dietic_mobil/screen/home/home-body.dart';
import 'package:dietic_mobil/screen/my_diary/home-fitness-app.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grock/grock.dart';
import 'package:dietic_mobil/screen/login/login.dart';
import '../screen/nav/nav.dart';
import '../service/login/login_service.dart';

class LoginRiverpod extends ChangeNotifier {
  final service = LoginService();
  final storage = FlutterSecureStorage();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final token ='';
  final emailString = '';
  final int id=0;

  void fetch() {
    service
        .loginCall(email: email!.text, password: password!.text)
        .then((value) async {
      if(value != null){
        await storage.write(key: 'token', value: value.accessToken);
       // await storage.write(key: 'username', value: value!.firstName);
        await storage.write(key: 'email', value: email.text);
        await storage.write(key: 'password', value: password.text);
        await storage.write(key: 'roleName', value: value.roleName);

        //await storage.write(key: 'id' ,value: value!.id.toString());
        if(value.roleName=='ROLE_PATIENT'){
                  Grock.to(FitnessAppHomeScreen());

        }
        if(value.roleName=='ROLE_DIETICIAN'){
            Grock.to(NavDieticianScreen());
        }

      }
      else if (value == null) {
       Grock.snackBar(
            title: "Hata",
            description: "Girilmiş olan kullanıcı verileri sistemdekiler ile eşleşmemektedir");

      }
      else {
        print('value null değil ama false geldi');

      }




    });
  }
}
