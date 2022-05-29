// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import '../home/HomeMap.dart';
import '../home/HomePage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController cpasswordController = new TextEditingController();
  PickedFile? _imageFile; //to store img
  final ImagePicker _picker = ImagePicker();
  String userImageUrl = "";

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    cpasswordController.dispose();

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
                margin: EdgeInsets.only(top: 20, left: 70),
                child: Column(
                  children: [
                    Text('Register',
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
            margin: EdgeInsets.only(left: 70),
            child: Column(
              children: [
                Container(
                    child: _imageFile == null
                        ? Image.asset('../assets/images/avatar.png')
                        : Image.file(File(_imageFile!.path))

                    //child:pickImage(),
                    ),
                Positioned(
                  bottom: 20.0,
                  right: 20.0,
                  child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: ((builder) => bottomSheet()),
                        );
                      },
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.teal,
                        size: 28.0,
                      )),
                )
              ],
            ),
          ),
        ),
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
                  color: Color.fromARGB(0, 98, 98, 131),
                  offset: Offset(0, 2),
                  blurRadius: 1)
            ],
            color: const Color(0xffF3F3F3),
          ),
          child: Align(
            child: Container(
              child: TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: "Username",
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
          margin: EdgeInsets.only(left: 70, top: 10),
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
                    labelText: "Email",
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
          margin: EdgeInsets.only(left: 70, top: 10),
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
                ),
              ),
            ),
          ),
        )),
        SafeArea(
            child: Container(
          margin: EdgeInsets.only(left: 70, top: 10),
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
                  controller: cpasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Comfirm Password",
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
              margin: EdgeInsets.only(left: 70, top: 20),
              child: ButtonTheme(
                minWidth: 350.0,
                height: 70.0,
                child: SizedBox(
                  height: 70,
                  width: 350,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: const Color(0xff699BF7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0))),
                    onPressed: () {
                      uploadAndSaveImage();
                    },
                    child: Text("Register",
                        style: GoogleFonts.outfit(
                            textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    /*color: const Color(0xff699BF7),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0))*/
                  ),
                ),
              )),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SafeArea(
                child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Transform.rotate(
                      angle: 180 * (3.14 / 180),
                      child: Container(
                          width: 150,
                          height: 5,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment(
                                    -1.3672882318496704, 0.0006440197466872633),
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
                margin: EdgeInsets.only(left: 9.5, right: 9.5, top: 10),
                child: Text(
                  'Or Sign in With',
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
                    margin: EdgeInsets.only(top: 10),
                    child: Transform.rotate(
                      angle: 0,
                      child: Container(
                          width: 150,
                          height: 5,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment(
                                    -1.3672882318496704, 0.0006440197466872633),
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
    )));
  }

  Widget bottomSheet() {
    return Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(children: <Widget>[
          Text(
            "Choose Profile Photo",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                  icon: Icon(Icons.camera),
                  onPressed: () {
                    takePhoto(ImageSource.camera);
                  },
                  label: Text("camera")),
              TextButton.icon(
                  icon: Icon(Icons.image),
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                  },
                  label: Text("gallery"))
            ],
          )
        ]));
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<void> uploadAndSaveImage() async {
    if (_imageFile != null) {
      passwordController.text == cpasswordController.text
          ? emailController.text.isNotEmpty &&
                  passwordController.text.isNotEmpty &&
                  usernameController.text.isNotEmpty
              ? uploadToStorage()
              : Fluttertoast.showToast(msg: "Please fill up the complete form")
          : Fluttertoast.showToast(msg: "Passwords do not match");
    } else {
      passwordController.text == cpasswordController.text
          ? emailController.text.isNotEmpty &&
                  passwordController.text.isNotEmpty &&
                  usernameController.text.isNotEmpty
              ? _registerUser()
              : Fluttertoast.showToast(msg: "Please fill up the complete form")
          : Fluttertoast.showToast(msg: "Passwords do not match");
    }
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async {
    User? firebaseUser;

    await _auth
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      firebaseUser = auth.user;
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              siteList: [],
            ),
          ));
    }).catchError((e) {
      Fluttertoast.showToast(msg: e!.message);
    });
    if (firebaseUser != null) {
      saveUserInfoToFirestore(firebaseUser);
    }
  }

  Future saveUserInfoToFirestore(User? fUser) async {
    FirebaseFirestore.instance.collection("users").doc(fUser!.uid).set({
      "uid": fUser.uid,
      "email": fUser.email,
      "name": usernameController.text.trim(),
      "url": userImageUrl,
      "role": "USER"
    });
  }

  uploadToStorage() async {
    String imageFileName = DateTime.now()
        .millisecondsSinceEpoch
        .toString(); // just to get a unique string
    firebase_storage.Reference storageReference =
        firebase_storage.FirebaseStorage.instance.ref(imageFileName);
    firebase_storage.UploadTask uploadTask =
        storageReference.putFile(File(_imageFile!.path));

    await uploadTask.whenComplete(() => null);
    //String userImageUrl ='';
    await storageReference.getDownloadURL().then((urlImage) {
      userImageUrl = urlImage;
      _registerUser();
    });
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

    ///  Get the email from selected google account
    var email = googleUser!.email;

    ///  Check the existence
    var methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    if (methods.contains('google.com')) {
      ///  User already signed-up with this google account
      Fluttertoast.showToast(msg: "User already exists");
    } else {
      ///  User is trying to sign-up for first time
      ///
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeMap(),
          ));
    }

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
