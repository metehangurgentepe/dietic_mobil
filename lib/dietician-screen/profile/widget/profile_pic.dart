import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = const Color(0xffeef444c);
  String profilePicLink = "";
  final storage = FlutterSecureStorage();


  void pickUploadProfilePic() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );

    Reference ref = FirebaseStorage.instance
        .ref().child("profilepic.jpg");

    await ref.putFile(File(image!.path));

    ref.getDownloadURL().then((value) async {
      setState(() {
        profilePicLink = value;
      });
      await storage.write(key: 'profile_pic', value:profilePicLink );
    });
  }
  @override
  void initState(){
    super.initState();
    String url= profilePicLink;

  }
    Future<String?> getProfilePic() async {
      String? value = await storage.read(key: 'profile_pic');
      return value;
    }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 115,
      width: 115,
      child: FutureBuilder(
        future: getProfilePic(),
        builder: (context,snapshot) {
          return Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
             profilePicLink == ' ' ? CircleAvatar(
                backgroundImage: AssetImage("assets/images/Profile Image.png"),
              ) : Image.network(snapshot.data ?? ''),
              Positioned(
                right: -16,
                bottom: 0,
                child: SizedBox(
                  height: 46,
                  width: 46,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: Colors.white),
                      ),
                      primary: Colors.white,
                      backgroundColor: Color(0xFFF5F6F9),
                    ),
                    onPressed:pickUploadProfilePic,
                    child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
                  ),
                ),
              )
            ],
          );
        }
      ),
    );
  }
}