import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../riverpod/riverpod_management.dart';


// firebase document id 142536475869
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String routeName = '/login';

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => LoginScreen(),
        settings: const RouteSettings(name: routeName));
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _obscureText=true;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  child: Image.asset("assets/images/dietic-logo.png"),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: ref.read(loginRiverpod).email,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              //Password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: ref.read(loginRiverpod).password,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureText=!_obscureText;
                            });
                          },
                          child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),
                        border: InputBorder.none,
                        hintText: "Şifre",
                      ),
                      obscureText: _obscureText,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              //Login button and (register now)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  padding: EdgeInsets.all(25),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      fixedSize: Size(300, 50),
                      backgroundColor: Colors.green[700],
                      side: BorderSide(
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        if(ref.read(loginRiverpod).password!.text != '' && ref.read(loginRiverpod).email!.text != ''){
                          print('burada');
                          ref.read(loginRiverpod).fetch();
                        }
                        else{
                        }
                      });
                    },
                    child: const Text("Giriş Yap",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                      ),),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.only(left: 55.0),
                child: Row(
                  children: [
                    Text('Üye değil misiniz?',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Segoe_UI',
                        color: Colors.grey,

                      ),
                    ),
                    TextButton(onPressed: () =>
                        Navigator.pushNamed(context, '/register'),
                      child: Text(
                        'Olmak için tıklayın',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Segoe_UI',
                          color: Colors.green,
                        ),
                      ),
                    ),
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

