import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'SignIn.dart';
import 'package:google_fonts/google_fonts.dart';


class ForgotPass extends StatefulWidget {
  const ForgotPass({ Key? key }) : super(key: key);

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {

  final _formKey = GlobalKey<FormState>();
  var email = "";
  final emailController =TextEditingController();

  resetPassword() async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.amber,
        content: Text('Password Reset Email has been sent',
        style: TextStyle(fontSize: 18.0),
        ),
        ),
        );

        Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=> signIn(),),
        );
    }on FirebaseAuthException catch(error){
    if(error.code == 'user-not-found'){
        print('No user found for that email');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.amber,
        content: Text('No user found for that email',
        style: TextStyle(fontSize: 18.0, color: Colors.amber
        ),
        ),
        ),
        );

      }

    }
  }

  @override
  void dispose() {
    
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar : AppBar(title: Text('Reset Passsword'),
      ),
       body : Column(
        children: [
          Padding(padding: const EdgeInsets.all(20.0),
          child: Image.network('https://media.istockphoto.com/vectors/young-woman-covering-her-ears-with-hands-scribble-and-question-marks-vector-id1335975919?k=20&m=1335975919&s=612x612&w=0&h=jFEBXQIPO8xb3XcIT9E90k6-QQQcNDCo0NCfT298Shs=')
          ),
          Container(
            margin:EdgeInsets.only(top: 20.0),
            child : Text('Reset Link will be sent to your email',
              style: GoogleFonts.outfit(
                      textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black))
            
             ),
          
          ),
          Expanded(child: Form(
            key: _formKey,
            child: Padding(padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 30.0),
            
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(autofocus: false,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Colors.black26,
                      fontSize: 15.0,
                    ),

                  ),
                  controller: emailController,
                  validator: (value){
                    if(value==null || value.isEmpty){
                      return 'Please enter email';

                    }else if(!value.contains('@')){
                      return 'Please enter a valid email';

                    }
                    return null;
                  },),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(onPressed:(){
                        if(_formKey.currentState!.validate()){
                          setState(() {
                            email=emailController.text;
                          });
                          resetPassword();
                        }
                      }, 
                      style: ElevatedButton.styleFrom(
                      primary:const Color(0xff699BF7),
                      fixedSize: const Size(200, 80),
                      ),
                      child: Text('Send email',
                        style: GoogleFonts.outfit(
                          textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)))
                      )
                    ],

                  ),
                )
              ],
           
            ),
            ),
          )
          )
       ],
      )
      
    );
  }
}