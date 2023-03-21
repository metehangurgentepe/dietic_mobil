import 'package:dietic_mobil/screen/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grock/grock.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final storage = new FlutterSecureStorage();
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: Icon(Icons.account_circle,color:Colors.green,size: 35,),
            press: () => {},
          ),
          ProfileMenu(
            text: "Notifications",
            icon:  Icon(Icons.notification_important,size: 35,),
            press: () {},
          ),
          ProfileMenu(
            text: "Settings",
            icon:  Icon(Icons.settings,size: 35),
            press: () {},
          ),
          ProfileMenu(
            text: "Help Center",
            icon:  Icon(Icons.help,size: 35),
            press: () {},
          ),
          ProfileMenu(
            text: "Log Out",
            icon:  Icon(Icons.logout,size: 35),
            press: () async {
              await storage.deleteAll();
              Grock.to(LoginScreen());
            },
          ),
        ],
      ),
    );
  }
}