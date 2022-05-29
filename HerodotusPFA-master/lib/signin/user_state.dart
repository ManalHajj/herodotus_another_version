import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Intro.dart';
import '../home/HomeMap.dart';
import '../home/HomePage.dart';

class UserState extends StatelessWidget {
  const UserState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.data == null) {
            return intro();
          } else if (userSnapshot.hasData) {
            return HomePage(
              siteList: [],
            );
          } else if (userSnapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('An error has occured. Try again later'),
              ),
            );
          }
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));
          }

          return Scaffold(
            body: Center(child: Text('Something went wrong')),
          );
        });
  }
}
