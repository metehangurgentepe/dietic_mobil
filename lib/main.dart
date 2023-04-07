import 'package:dietic_mobil/screen/home/home-body.dart';
import 'package:dietic_mobil/screen/home/home.dart';
import 'package:dietic_mobil/screen/login/login.dart';
import 'package:dietic_mobil/screen/nav/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dietic_mobil/config/routes/routers.dart';
import 'package:grock/grock.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {

  runApp(ProviderScope(child: MyApp()));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, widget) {
          return MaterialApp(
            navigatorKey: Grock.navigationKey, // added line
            scaffoldMessengerKey: Grock.scaffoldMessengerKey,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            debugShowCheckedModeBanner: false,
            initialRoute: NavScreen.routeName,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        }
    );
  }
}

