import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:map/Entities/Badge.dart';
import 'package:map/Entities/Bookmarks.dart';
import 'signin/SignIn.dart';

class SideBar extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;

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
                  user.photoURL.toString(),
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
