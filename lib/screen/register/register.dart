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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children:[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                    child: Image.asset("assets/images/dietic-logo.png",height:150)
                ),
              ),


              SizedBox(height: 30),

              Text(
                'Üye Ol',
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w500,
                  fontSize: 42,
                  color: Colors.black,
                ),
              ),

              SizedBox(height:30),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(

                    color: Colors.white,
                    border:Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left:20.0),
                    child: TextField(
                      controller: ref.read(registerRiverpod).firstName,
                      decoration: InputDecoration(
                        border : InputBorder.none,
                        hintText: 'Ad',
                      ),
                    ),
                  ),
                ),

              ),

              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(

                    color: Colors.white,
                    border:Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left:20.0),
                    child: TextField(
                      controller: ref.read(registerRiverpod).lastName,
                      decoration: InputDecoration(
                        border : InputBorder.none,
                        hintText: 'Soyad',
                      ),
                    ),
                  ),
                ),

              ),
              SizedBox(height: 10),

              //Password
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(

                    color: Colors.white,
                    border:Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left:20.0),
                    child: TextField(
                      controller: ref.read(registerRiverpod).email,
                      decoration: InputDecoration(
                        border : InputBorder.none,
                        hintText: "Email",
                      ),
                    ),
                  ),
                ),

              ),

              SizedBox(height: 10),

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
                      controller: ref.read(registerRiverpod).password,
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


              SizedBox(height: 10),

              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border:Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:  Padding(
                    padding: EdgeInsets.only(left:20.0),
                    child: TextField(
                      decoration: InputDecoration(
                        border : InputBorder.none,
                        hintText: "Tekrar Şifre",
                      ),
                      obscureText: true,
                    ),
                  ),
                ),

              ),
              SizedBox(height: 10),

              Padding(padding: EdgeInsets.symmetric(horizontal: 19,vertical: 15),
                  child: Row(
                    children: [

                      Checkbox(
                          value: isChecked,
                          onChanged:(bool? value){
                            setState(() {
                              isChecked = value!;
                            });
                          }),
                      Text('Üyelik Formu Aydınlatma Metnini Okudum.'),
                    ],
                  )),






              SizedBox(height: 10),


              //Login button and (register now)
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  padding: EdgeInsets.all(25),
                  child:TextButton(
                    style: TextButton.styleFrom(
                        fixedSize: Size(300, 50),
                        backgroundColor: Colors.green[700],
                        side: BorderSide(
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)
                        )
                    ),
                    onPressed:(){

                        setState(() {
                          if(ref.read(registerRiverpod).password!.text != '' && ref.read(registerRiverpod).email!.text != '' && ref.read(registerRiverpod).firstName!.text != '' && ref.read(registerRiverpod).lastName!.text != '' ){
                            print('burada');
                            ref.read(registerRiverpod).fetch();
                          }
                          else{
                          }
                        });
                    },
                    child: Text(
                      "Kayıt Ol",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
