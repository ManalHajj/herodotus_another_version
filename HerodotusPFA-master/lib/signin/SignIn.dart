import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../home/HomeMap.dart';
import 'Forgot_pass.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../home/HomePage.dart';
import 'Authentication.dart';

class signIn extends StatefulWidget {
  const signIn({Key? key}) : super(key: key);
  @override
  _signInState createState() => _signInState();
}

class _signInState extends State<signIn> {
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          SafeArea(
              child: Container(
                  margin: EdgeInsets.only(top: 76, left: 70),
                  child: Column(
                    children: [
                      Text('Welcome back',
                          //textAlign: TextAlign.left,
                          style: GoogleFonts.outfit(
                            textStyle: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff464444)),
                          ))
                    ],
                  ))),
          SafeArea(
              child: Container(
            margin: EdgeInsets.only(top: 50, left: 70),
            width: 339,
            height: 59,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xff0000001f),
                    offset: Offset(0, 2),
                    blurRadius: 1)
              ],
              color: const Color(0xffF3F3F3),
            ),
            child: Align(
              child: Container(
                child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Username , Email & Phone Number",
                      labelStyle: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w600,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    )),
              ),
            ),
          )),
          SafeArea(
              child: Container(
            margin: EdgeInsets.only(top: 20, left: 70),
            width: 339,
            height: 59,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xff0000001f),
                    offset: Offset(0, 2),
                    blurRadius: 1)
              ],
              color: const Color(0xffF3F3F3),
            ),
            child: Align(
              child: Container(
                child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w600,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    )),
              ),
            ),
          )),
          SafeArea(
              child: Container(
                  margin: EdgeInsets.only(top: 20, left: 290),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPass(),
                            ));
                      },
                      child: Text("Forgot Password ?",
                          style: GoogleFonts.outfit(
                              textStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff2D2626))))))),
          SafeArea(
            child: Container(
                margin: EdgeInsets.only(top: 40, left: 70),
                child: ButtonTheme(
                  minWidth: 350.0,
                  height: 70.0,
                  child: SizedBox(
                    height: 70,
                    width: 300,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: const Color(0xff699BF7),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0))),
                      onPressed: () {
                        authentication(
                            emailController.text, passwordController.text);
                      },
                      child: Text("Sign in",
                          style: GoogleFonts.outfit(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                      /* color: const Color(0xff699BF7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0))
                            */
                    ),
                  ),
                )),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SafeArea(
                  child: Container(
                      margin: EdgeInsets.only(top: 40),
                      child: Transform.rotate(
                        angle: 180 * (3.14 / 180),
                        child: Container(
                            width: 150,
                            height: 5,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment(-1.3672882318496704,
                                      0.0006440197466872633),
                                  end: Alignment(-0.0006440196884796023,
                                      -0.0007062439690344036),
                                  colors: [
                                    const Color(0xff699BF7),
                                    Color.fromRGBO(196, 196, 196, 0)
                                  ]),
                            )),
                      ))),
              SafeArea(
                child: Container(
                  margin: EdgeInsets.only(top: 40, left: 9.5, right: 9.5),
                  child: Text(
                    'Or Sign up With',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xff555252),
                      fontFamily: 'Outfit',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SafeArea(
                  child: Container(
                      margin: EdgeInsets.only(top: 40),
                      child: Transform.rotate(
                        angle: 0,
                        child: Container(
                            width: 150,
                            height: 5,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment(-1.3672882318496704,
                                      0.0006440197466872633),
                                  end: Alignment(-0.0006440196884796023,
                                      -0.0007062439690344036),
                                  colors: [
                                    const Color(0xff699BF7),
                                    Color.fromRGBO(196, 196, 196, 0)
                                  ]),
                            )),
                      ))),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SafeArea(
                  child: Container(
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: const Color(0xff699BF7),
                  border: Border.all(
                    color: const Color(0xffECE9EC),
                    width: 14,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Align(
                  child: Container(
                      height: 35,
                      width: 45,
                      child: SignInButton(
                        Buttons.Google,
                        text: "",
                        onPressed: () {
                          signInWithGoogle();
                        },
                      )),
                ),
              )),
              SafeArea(
                  child: Container(
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: const Color(0xffECE9EC),
                  border: Border.all(
                    color: const Color(0xffECE9EC),
                    width: 9,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Align(
                  child: Container(
                      child: SignInButton(
                    Buttons.Facebook,
                    mini: true,
                    onPressed: () {},
                  )),
                ),
              )),
            ],
          )
        ],
      )),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    var email = googleUser!.email;

    ///  Check the existence
    var methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    if (methods.contains('google.com')) {
      ///  User already signed-up with this google account
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              siteList: [],
            ),
          ));
    } else {
      ///  User is trying to sign-up for first time
      Fluttertoast.showToast(msg: "U have to register first");
    }
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void authentication(String email, String password) async {
    final _auth = FirebaseAuth.instance;
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((uid) => {
              Fluttertoast.showToast(msg: "Login Sucessful"),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      siteList: [],
                    ),
                  ))
            })
        .catchError((e) {
      print(e);
    });
  }
}
