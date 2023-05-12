import 'package:dietic_mobil/service/update_profile_pic/update_profile_pic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../model/user_model.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatefulWidget {
  Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final storage = new FlutterSecureStorage();
  final service = UpdateProfilePic();
  UserModel? user;

  @override
  void initState() {
    service.getProfilePic().then((value) {
      setState(() {
        user = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          SizedBox(height: 30),
          ProfilePic(),
          SizedBox(height: 50),
          //UserInformation(),
          Column(
            children: [
              Text.rich(TextSpan(
                  text: '${user!.name} ${user!.surname} ',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
              Text.rich(TextSpan(
                  text: '${user!.email} ', style: TextStyle(fontSize: 15)))
            ],
          ),
          ProfileMenu(
            text: "My Account",
            icon: "assets/icons/User Icon.svg",
            press: () => {Navigator.pushNamed(context, '/update_profile',arguments: user)},
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
            press: () async {
              await FirebaseAuth.instance.signOut();
              await storage.deleteAll();
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  Widget UserInformation() {
    final service = UpdateProfilePic();
    UserModel? user;
    service.getProfilePic().then((value) {
      user = value;
    });
    return Column(
      children: [
        Text('${user!.name} ${user!.surname}'),
        Text('${user!.email}')
      ],
    );
  }
}
