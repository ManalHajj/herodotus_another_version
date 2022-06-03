import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:map/Entities/Badge.dart';
import 'package:map/Entities/Bookmarks.dart';
import 'signin/SignIn.dart';

class SideBar extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  String pic(String img) {
    if (user.photoURL == null) {
      return "https://images.unsplash.com/photo-1528543606781-2f6e6857f318?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1965&q=80";
    }
    return img;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('${user.displayName}'),
            accountEmail: Text(user.email.toString()),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  pic(user.photoURL.toString()),
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
            ),
          ),
          ListTile(
            title: Text('Badges'),
            leading: Icon(Icons.videogame_asset),
            /*onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ),
            )*/
          ),
          ListTile(
              title: Text('Bookmarks'),
              leading: Icon(Icons.bookmark),
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Boomarks()),
                  )),
          ListTile(
            title: Text('LogOut'),
            leading: Icon(Icons.exit_to_app),
            onTap: () => _signOut(),
          ),
        ],
      ),
    );
  }

  Future<signIn> _signOut() async {
    await FirebaseAuth.instance.signOut();

    return new signIn();
  }
}
/*  ListTile(
            title: Text('LogOut'),
            leading: Icon(Icons.exit_to_app),
            onTap: () => _signOut(),
          ),*/
