import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/MAYteam/AdminPage.dart';
import 'package:flutter_app/MAYteam/Auth_functions.dart';
import 'package:flutter_app/MAYteam/Firebase_functions.dart';
import 'package:flutter_app/MAYteam/SideFunctions.dart';
import 'package:flutter_app/MAYteam/SignUpPage.dart';
import 'package:flutter_app/main.dart';
import 'GameGroupPage.dart';

class SignInPage extends StatefulWidget {
  final Function toggleView;
  SignInPage({this.toggleView});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String email = '';
  String password = '';
  String error = '';

  _onSignIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      await _auth.signInWithEmailAndPassWord(email, password).then((
          result) async {
        if (result != null) {
          QuerySnapshot userInfoSnapshot = await FirebaseFunctions()
              .   getUserData(email);

          await SideFunctions.saveUserLoggedInSharedPreference(true);
          await SideFunctions.saverUserEmailSharedPreference(email);
          await SideFunctions.saveUserNameSharedPreference(userInfoSnapshot.docs[0].get('fullName'));

          if(email == 'taneri862@gmail.com') {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AdminPage()));
          }
          else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
          }
        }
        else {
          setState(() {
            error = 'Error signing in!';
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.brown[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyApp()),
          ),
        ),
      ),
      body: Form(
          key: _formKey,
          child: Container(
            alignment: Alignment.center,
            color: Colors.brown[900],
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    Text("Sign In",
                        style: TextStyle(color: Colors.white, fontSize: 25.0)),
                    SizedBox(height: 20.0),
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
                          email = val;
                        });
                      },
                    ),
                    SizedBox(height: 15.0),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'PASSWORD'
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (val) =>
                      val.length < 6
                          ? 'Password not strong enough'
                          : null,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: MaterialButton(
                          elevation: 0.0,
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0)),
                          child: Text('Sign In', style: TextStyle(
                              color: Colors.white, fontSize: 16.0)),
                          onPressed: () {
                            _onSignIn();
                          }
                      ),
                    ),
                    SizedBox(height: 25.0),
                    Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Register here',
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline
                            ),
                            recognizer: TapGestureRecognizer()
                          ..onTap = ()  {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RegisterPage()));
                          },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0)),
                  ],
                ),
              ],
            ),
          )
      ),
    );
  }
}