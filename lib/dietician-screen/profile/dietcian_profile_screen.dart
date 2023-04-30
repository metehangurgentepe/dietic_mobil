import 'package:dietic_mobil/dietician-screen/profile/widget/body.dart';
import 'package:flutter/material.dart';

class ProfilesScreen extends StatelessWidget {
  static String routeName = "/profile";

  const ProfilesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BodyDietician(),
    );
  }
}