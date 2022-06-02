import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Details/Comments.dart';
import 'Feed/feed_screen.dart';
import 'home/MapPreferences.dart';
import 'home/SearchBar.dart';
import 'signin/user_state.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await MapPreferences.init().then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  //const MyApp({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /*return FutureBuilder(
    future: _initialization,
    builder: (context, snapshot) {
      if(snapshot.hasError){
         print("Something went wrong");
      }
     if(snapshot.connectionState==ConnectionState.waiting){
       return Center(child: CircularProgressIndicator()
       );
     }*/

    return MaterialApp(
      builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget!),
          maxWidth: 1200,
          minWidth: 480,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(480, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.resize(1000, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: '4K'),
          ],
          background: Container(color: Color(0xFFF5F5F5))),
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: UserState(),
      //CommentScreen(),

      //FeedScreen(),
      //SearchBar(),
      //PlacedetailsWidget(),
      //UserState(),
    );
    //},
    //);
  }
}
