import 'package:dietic_mobil/message/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth_screen';

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => AuthScreen(),
        settings: const RouteSettings(name: routeName));
  }
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    var providers = [EmailAuthProvider()];
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
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
