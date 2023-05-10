import 'dart:io';

import 'package:dietic_mobil/service/update_profile_pic/update_profile_pic.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/user_model.dart';

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
  final service =UpdateProfilePic();
  UserModel? user;


  void pickUploadProfilePic() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
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
        print(profilePicLink);
      });
      if(profilePicLink.contains('firebase')){
        service.postProfilePic(profilePicLink);
      }
      
      await prefs.setString('profile_pic', profilePicLink);
    });
  }
  @override
  void initState(){
    
    super.initState();
    service.getProfilePic().then((value){
      setState(() {
        user=value;
      });
      
    });
  }
    

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 115,
      width: 115,
      child: FutureBuilder(
        future: service.getProfilePic(),
        builder: (context,snapshot) {
          
          print(snapshot.data);
          return Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
             snapshot.data==null ? Icon(Icons.person_2_outlined) : Container(child: Image.network(user!.picture ?? '')),
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