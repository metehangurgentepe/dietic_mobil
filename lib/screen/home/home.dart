import 'package:flutter/material.dart';
import 'home-body.dart';

class HomeScreen extends StatelessWidget {

  static const String routeName = '/home';
  const HomeScreen({ Key? key }) : super(key: key);
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => HomeScreen(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  Widget build(BuildContext context) {
    return HomeBody();
  }
}