import 'package:flutter/material.dart';
import 'package:dietic_mobil/screen/profile/widget/body.dart';

class ProfilesScreen extends StatelessWidget {

  const ProfilesScreen({Key? key}) : super(key: key);

  static const String routeName = "/profiles";

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => ProfilesScreen(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Body(),
    ));
  }
}
