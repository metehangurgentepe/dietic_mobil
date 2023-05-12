import 'package:dietic_mobil/service/update_profile_pic/update_profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../model/user_model.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class BodyDietician extends StatefulWidget {
  @override
  State<BodyDietician> createState() => _BodyDieticianState();
}

class _BodyDieticianState extends State<BodyDietician> {
  final storage = new FlutterSecureStorage();
  final service = UpdateProfilePic();
  UserModel? user;
  String name = '';
  String email = '';
  @override
  void initState() {
    service.getProfilePic().then((value) {
      setState(() {
        user = value;
      });
      name = '${user!.name} ${user!.surname}';
      email='${user!.email}';
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
          SizedBox(height: 20),
          Column(
            children: [
              Text.rich(TextSpan(
                  text: name,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
              Text.rich(TextSpan(
                  text: email, style: TextStyle(fontSize: 15)))
            ],
          ),
          SizedBox(height: 30),
          ProfileMenu(
            text: "My Account",
            icon: "assets/icons/User Icon.svg",
            press: () => {},
          ),
          ProfileMenu(
            text: "Appointment",
            icon: "assets/icons/calendar.svg",
            press: () {
              Navigator.pushNamed(context, '/choose_patient');
            },
          ),
          ProfileMenu(
            text: "Appointment",
            icon: "assets/icons/Call.svg",
            press: () {
              Navigator.pushNamed(context, '/show-appointment');
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
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
