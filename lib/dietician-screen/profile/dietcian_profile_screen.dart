import 'package:dietic_mobil/dietician-screen/profile/widget/body.dart';
import 'package:flutter/material.dart';

class DietitianProfilesScreen extends StatelessWidget {
  static String routeName = "/dietitian-profile";

  const DietitianProfilesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BodyDietician(),
    );
  }
}