import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {

  bool _isLoading = false;
  String _email = '';
  final _user = FirebaseAuth.instance;

  void _sendMail(String email) async {
    setState(() {
      _isLoading = true;
    });
    await _user.sendPasswordResetEmail(email: email);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       elevation: 0.0,
       backgroundColor: Colors.brown[900],
       leading: IconButton(
         icon: Icon(Icons.arrow_back, color: Colors.white),
         onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyApp())
         ),
       ),
     ),
     body: Container(
       padding: EdgeInsets.symmetric(horizontal: 30.0),
       color: Colors.brown[900],
       alignment: Alignment.center,
       child: ListView(
         children: <Widget>[
           SizedBox(height: 70.0),
           Icon(Icons.email_outlined, size: 100.0),
           SizedBox(height: 20.0),
           Text('Please Enter Your E-Mail !', style: TextStyle(fontSize: 30.0)),
           SizedBox(height: 30.0),
           TextFormField(
             decoration: InputDecoration(
                 hintText: 'EMAIL'
             ),
             style: TextStyle(color: Colors.white),
             validator: (val) {
               return RegExp(
                   r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                   .hasMatch(val)
                   ? null
                   : "Please enter a valid email";
             },
             onChanged: (val) {
               setState(() {
                 _email = val;
               });
             },
           ),
           SizedBox(height: 40.0),
           MaterialButton(
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
               color: Colors.red,
               child: _isLoading ? CircularProgressIndicator(color: Colors.black, strokeWidth: 3.5) : Text('Send Verification E-mail'),
               onPressed: () {
                 _sendMail(_email);
               }
           ),
         ],
       ),
     ),
   );
  }
}