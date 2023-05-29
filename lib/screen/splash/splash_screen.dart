import 'dart:async';
import 'dart:io';

import 'package:Dietic/config/theme/fitness_app_theme.dart';
import 'package:Dietic/screen/login/login.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grock/grock.dart';

import '../../dietician-screen/nav/nav_dietician.dart';
import '../../service/login/login_service.dart';
import '../my_diary/home-fitness-app.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = '/splash-screen';

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => SplashScreen(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final storage = new FlutterSecureStorage();
    final service = LoginService();

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () async {
      String? email = await storage.read(key: 'email');
      String? password = await storage.read(key: 'password');
      service.loginCall(email: email ?? '', password: password ?? '').then((value) async {
        if(value!=null){
        await storage.write(key: 'token', value: value.accessToken);

        await storage.write(key: 'patientId', value: value.accessToken);
        if(value.roleName=='ROLE_PATIENT'){
                  Grock.to(FitnessAppHomeScreen());
        }
        if(value.roleName=='ROLE_DIETICIAN'){
            Grock.to(NavDieticianScreen());
        }
        }
      });

      Grock.to(LoginScreen());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: FitnessAppTheme.nearlyWhite,
      child:Image.asset('assets/images/dietic-logo.png')
    );
  }
}