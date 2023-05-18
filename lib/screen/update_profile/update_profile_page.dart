import 'package:dietic_mobil/config/theme/fitness_app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../config/theme/theme.dart';
import '../../model/user_model.dart';

class UpdateProfileScreen extends StatefulWidget {
  UpdateProfileScreen({Key? key, required this.user}) : super(key: key);
  static const String routeName = '/update_profile';

  static Route route({required UserModel user}) {
    return MaterialPageRoute(
        builder: (_) => UpdateProfileScreen(user: user),
        settings: const RouteSettings(name: routeName));
  }

  final UserModel user;

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(widget.user.picture);
    bool isPasswordVisible = false;
    //final controller = Get.put(ProfileController());
    String name = '${widget.user.name} ${widget.user.surname}';
    name = nameController.text;
    String email =widget.user.email!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.colorAccent,
        title:
            Text('EditProfile',)
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.only(top:18.0),
            child: Column(
              children: [
                // -- IMAGE with ICON
                Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: widget.user.picture==null ? Image.asset('assets/images/user.png') : Image(
                              image: NetworkImage('${widget.user.picture}'))),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: FitnessAppTheme.dark_grey),
                        child: const Icon(LineAwesomeIcons.camera,
                            color: Colors.black, size: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Column(
            children: [
              Text.rich(TextSpan(
                  text: name,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
              Text.rich(TextSpan(text: email, style: TextStyle(fontSize: 15)))
            ],
          ),

          
                // -- Form Fields
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CupertinoTextField.borderless(
                            cursorColor: FitnessAppTheme.nearlyDarkBlue,
                            controller: nameController,
                            padding: EdgeInsets.only(
                                left: 15, top: 10, right: 6, bottom: 10),
                            prefix: Text('Full Name'),
                            placeholder: 'Required'),
                        Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                        
                        CupertinoTextField.borderless(
                          obscureText: !isPasswordVisible,
                          controller: passwordController,
                            cursorColor: FitnessAppTheme.nearlyDarkBlue,
                          padding: EdgeInsets.only(
                              left: 15, top: 10, right: 6, bottom: 10),
                          prefix: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text('Password'),
                          ),
                          placeholder: 'Required',
                        )
                      ],
                    ),
                  ),
                ),
                // -- Created Date and Delete Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text.rich(
                      TextSpan(
                        text: 'Join',
                        style: TextStyle(fontSize: 12),
                        children: [
                          TextSpan(
                              text: 'Join',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12))
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent.withOpacity(0.1),
                          elevation: 0,
                          foregroundColor: Colors.red,
                          shape: const StadiumBorder(),
                          side: BorderSide.none),
                      child: const Text('Change'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
