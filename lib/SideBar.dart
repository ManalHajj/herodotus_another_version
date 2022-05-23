import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'signin/SignIn.dart';
import 'signin/Authentication.dart';

class SideBar extends StatelessWidget {
  const SideBar({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
           ListTile(
            title: Text('LogOut'),
            leading: Icon(Icons.exit_to_app),
            onTap: () => _signOut()  ,
          ),
        ],
      ),
      
    );
  }
  Future <signIn> _signOut()  async{
    await FirebaseAuth.instance.signOut();

    return new signIn();
}
}