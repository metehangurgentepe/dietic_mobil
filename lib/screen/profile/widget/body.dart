import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  final storage = new FlutterSecureStorage();

  Body({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          SizedBox(height: 30),
          ProfilePic(),
          SizedBox(height: 50),
          ProfileMenu(
            text: "My Account",
            icon: "assets/icons/User Icon.svg",
            press: () => {},
          ),
          ProfileMenu(
            text: "Appointment",
            icon: "assets/icons/calendar.svg",
            press: () {
              Navigator.pushNamed(context, '/appointment');
            },
          ),
          ProfileMenu(
            text: "Your Appointments",
            icon: "assets/icons/Bell.svg",
            press: () {
              Navigator.pushNamed(context, '/show-appointment-patient');
            },
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Help Center",
            icon: "assets/icons/Question mark.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () async  {
              await FirebaseAuth.instance.signOut();
              await storage.deleteAll();
              Navigator.pushNamed(context,'/login');
            },
          ),
        ],
      ),
    );
  }
}