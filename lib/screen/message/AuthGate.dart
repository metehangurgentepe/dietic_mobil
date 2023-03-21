import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:dietic_mobil/screen/message/message_screen.dart';

class AuthGate extends StatelessWidget {


  const AuthGate({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
        if(snapshot.hasData){
          return MessageScreen();
        }
        else{
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










    /*MaterialApp(
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/profile',
      routes: {
        '/sign-in': (context) {
          return SignInScreen(
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                if (!state.user!.emailVerified) {
                  Navigator.pushNamed(context, '/verify-email');
                } else {
                  Navigator.pushReplacementNamed(context, '/profile');
                }
              }),
            ],
          );
        },
      },
    );*/
  }
}
