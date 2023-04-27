import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../riverpod/riverpod_management.dart';
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static const String routeName = '/register';


  static Route route() {
    return MaterialPageRoute(
        builder: (_) => SignUpScreen(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  bool isChecked=false;

  bool _obscureText=true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
      ),
      body: SafeArea(
        child: Expanded(
          child: Center(
            child: Text('Ne yazık ki sizi kayıt edemiyoruz. Diyetisyeninizle iletişime geçip kayıt olabilirsiniz',style: TextStyle(fontSize: 20),textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
