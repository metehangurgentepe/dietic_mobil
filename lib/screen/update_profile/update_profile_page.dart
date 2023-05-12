import 'package:dietic_mobil/config/theme/fitness_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../config/theme/theme.dart';
import '../../model/user_model.dart';

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({Key? key, required this.user}) : super(key: key);
  static const String routeName = '/update_profile';

  static Route route({required UserModel user}) {
    return MaterialPageRoute(
        builder: (_) => UpdateProfileScreen(user: user),
        settings: const RouteSettings(name: routeName));
  }

  final UserModel user;
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //final controller = Get.put(ProfileController());
    String name = '${user.name} ${user.surname}';
    name = nameController.text;
    return Scaffold(
      appBar: AppBar(
        
        title:
            Text('EditProfile', style: Theme.of(context).textTheme.headline4),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8),
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
                        child: Image(image: NetworkImage('${user.picture}'))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppColors.colorAccent),
                      child: const Icon(LineAwesomeIcons.camera,
                          color: Colors.black, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // -- Form Fields
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          label: Text('Full name'),
                          prefixIcon: Icon(LineAwesomeIcons.user)),
                    ),
                    const SizedBox(height: 50 - 20),
                    TextFormField(
                      decoration: const InputDecoration(
                          label: Text('email'),
                          prefixIcon: Icon(LineAwesomeIcons.envelope_1)),
                    ),
                    const SizedBox(height: 50 - 20),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        label: const Text('Password'),
                        prefixIcon: const Icon(Icons.fingerprint),
                        suffixIcon: IconButton(
                            icon: const Icon(LineAwesomeIcons.eye_slash),
                            onPressed: () {}),
                      ),
                    ),
                    const SizedBox(height: 50),

                    // -- Form Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: FitnessAppTheme.nearlyWhite,
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: const Text('EditProfile',
                            style: TextStyle(color: AppColors.colorAccentDark)),
                      ),
                    ),
                    const SizedBox(height: 30),

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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12))
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.redAccent.withOpacity(0.1),
                              elevation: 0,
                              foregroundColor: Colors.red,
                              shape: const StadiumBorder(),
                              side: BorderSide.none),
                          child: const Text('Delete'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
