import 'package:Dietic/message/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../riverpod/riverpod_management.dart';

class AuthScreen extends ConsumerStatefulWidget {
  static const String routeName = '/auth_screen';

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => AuthScreen(),
        settings: const RouteSettings(name: routeName));
  }
  const AuthScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    //   void signUserIn() async {
    // // show loading circle
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return const Center(
    //       child: CircularProgressIndicator(),
    //     );
    //   },
    // );

    // // try sign in
    // try {
    //   await FirebaseAuth.instance.signInWithEmailAndPassword(
    //     email: ref.read(loginRiverpod).email.text,
    //     password: ref.read(loginRiverpod).password.text,
    //   );

    //   final SharedPreferences prefs = await SharedPreferences.getInstance();
    //   await prefs.setString('email',ref.read(loginRiverpod).email.text );
    //   await prefs.setString('password',ref.read(loginRiverpod).password.text );


    //   // pop the loading circle
    //   Navigator.pop(context);
    // } on FirebaseAuthException catch (e) {
    //   // pop the loading circle
    //   Navigator.pop(context);
    //   // WRONG EMAIL
      
    // }}
   var providers = [EmailAuthProvider()];
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //signUserIn();
          if (snapshot.hasData) {
            return MyHomePage();
          }
          else {
            return SignInScreen(
              providers: [EmailAuthProvider()],
              actions: [
                AuthStateChangeAction<SignedIn>((context, state) {
                  Navigator.pushReplacementNamed(context, '/profile');
                }),
              ],

            );
          }
        });
  }
}
