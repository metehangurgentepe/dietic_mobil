import 'package:dietic_mobil/dietician-screen/nav/nav_dietician.dart';
import 'package:dietic_mobil/screen/home/home-body.dart';
import 'package:dietic_mobil/screen/my_diary/home-fitness-app.dart';
import 'package:dietic_mobil/service/patient_detail/patient_detail_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grock/grock.dart';
import 'package:dietic_mobil/screen/login/login.dart';
import '../screen/nav/nav.dart';
import '../service/login/login_service.dart';

class LoginRiverpod extends ChangeNotifier {
  final service = LoginService();
  final storage = FlutterSecureStorage();
  final patient_service = PatientDetailService();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final token = '';
  final emailString = '';
  final int id = 0;

  void fetch() {
    service
        .loginCall(email: email.text, password: password.text)
        .then((value) async {
      if (value != null) {
        await storage.write(key: 'token', value: value.accessToken);
        await storage.write(key: 'email', value: email.text);
        await storage.write(key: 'password', value: password.text);
        await storage.write(key: 'roleName', value: value.roleName);
        if (value.roleName == 'ROLE_PATIENT') {
          await storage.write(key: 'dietitianId', value: value.dietitianId.toString());
          await storage.write(key: 'patientId', value: value.id.toString());
          // patient_service.getPatientDetail().then((value) async {
          //   await storage.write(key: 'weight', value: value.weight.toString());
          //   await storage.write(key: 'height', value: value.height.toString());
          //   await storage.write(key: 'age', value: value.age.toString());
          //   await storage.write(
          //       key: 'bodyFat', value: value.bodyFat.toString());
          // });

          Grock.to(FitnessAppHomeScreen());
        }
        if (value.roleName == 'ROLE_DIETITIAN') {
          await storage.write(key: 'dietitian-name', value: value.name);
          await storage.write(key: 'dietitianId', value: value.id.toString());
          Grock.to(NavDieticianScreen());
        }
      } else if (value == null) {
        Grock.snackBar(
            title: "Hata",
            description:
                "Girilmiş olan kullanıcı verileri sistemdekiler ile eşleşmemektedir");
      } else {
        print('value null değil ama false geldi');
      }
    });
  }
}
