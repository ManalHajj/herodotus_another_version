import 'package:flutter/material.dart';
import 'signin/Authentication.dart';
import 'signin/Register.dart';
import 'signin/SignIn.dart';
import 'package:google_fonts/google_fonts.dart';

class intro extends StatelessWidget {
  const intro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
          child: Image.asset("assets/images/Herodotus.png"),
        ),
        Container(
            padding: EdgeInsets.only(top: 40),
            child: Text("Be the new",
                style: GoogleFonts.outfit(
                  textStyle: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ))),
        Container(
          child: RichText(
            text: TextSpan(children: <TextSpan>[
              TextSpan(
                  text: "Hero",
                  style: GoogleFonts.outfit(
                      textStyle: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black))),
              TextSpan(
                  text: "dotus",
                  style: GoogleFonts.outfit(
                      textStyle: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff699BF7)))),
            ]),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ButtonTheme(
                  minWidth: 200.0,
                  height: 70.0,
                  child: TextButton(
                    onPressed: () {
                      //signOutGoogle();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return signIn();
                          },
                        ),
                      );
                    },
                    child: Text("Sign in",
                        style: GoogleFonts.outfit(
                            textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    /*color: const Color(0xff699BF7),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),*/
                  )),
              ButtonTheme(
                  minWidth: 200.0,
                  height: 70.0,
                  child: TextButton(
                    onPressed: () {
                      //signOutGoogle();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Register();
                          },
                        ),
                      );
                    },
                    child: Text("Register",
                        style: GoogleFonts.outfit(
                            textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                    /*color: const Color(0xffF3F3F3),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0))),*/
                  ))
            ],
          ),
        )
      ]),
    );
  }
}
