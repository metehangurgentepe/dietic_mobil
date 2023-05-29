import 'package:Dietic/screen/home/home-body.dart';
import 'package:Dietic/screen/home/home.dart';
import 'package:Dietic/screen/login/login.dart';
import 'package:Dietic/screen/my_diary/home-fitness-app.dart';
import 'package:Dietic/screen/nav/nav.dart';
import 'package:Dietic/screen/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Dietic/config/routes/routers.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grock/grock.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dietician-screen/nav/nav_dietician.dart';
import 'firebase_options.dart';
import 'package:camera/camera.dart';


void main() async {
  /*WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();


  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;*/
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
            initialRoute: SplashScreen.routeName,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        }
    );
  }
}

