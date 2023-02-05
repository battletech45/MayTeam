import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:MayTeam/MAYteam/LoginPage.dart';
import 'package:MayTeam/MAYteam/VerificationPage.dart';
import 'package:MayTeam/main.dart';
import 'SideFunctions.dart';
import 'Auth_functions.dart';
import 'GameGroupPage.dart';

class RegisterPage extends StatefulWidget {
  final Function toggleView;
  RegisterPage({this.toggleView});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _user = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _isUserUnique = true;

  String fullName = '';
  String email = '';
  String password = '';
  String error = '';

  _onRegister() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      await _checkUserNameExistence(fullName);
      if(_isUserUnique) {
        await _auth.registerWithEmailAndPassword(fullName, email, password).then((result) async {
          if (_user.currentUser.emailVerified) {
            if (result != null) {
              await SideFunctions.saveUserLoggedInSharedPreference(true);
              await SideFunctions.saverUserEmailSharedPreference(email);
              await SideFunctions.saveUserNameSharedPreference(fullName);

              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomePage()));
            }
            else {
              setState(() {
                error = 'Error while registering the user!';
                _isLoading = false;
              });
            }
          }
          else {
            _user.currentUser.sendEmailVerification();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => VerificationPage()));
            print("mail sent");
          }
        });
      }
      else {
        setState(() {
          error = 'UserName is not unique !';
        });
      }
    }
  }

  _checkUserNameExistence(String userName) async {
    setState(() {
      _isUserUnique = true;
    });
    var snapshot = await FirebaseFirestore.instance.collection("users").get();
    for (var i = 0; i < snapshot.docs.length; i ++) {
      if (snapshot.docs[i].get("fullName") == userName) {
        setState(() {
          _isUserUnique = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 60.0),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    Text("Register", style: TextStyle(color: Colors.white, fontSize: 25.0)),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'NAME'
                      ),
                      style: TextStyle(color: Colors.white),
                      onChanged: (val) {
                        setState(() {
                          fullName = val;
                        });
                      },
                    ),
                    SizedBox(height: 15.0),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'EMAIL',
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (val) {
                        return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Please enter a valid email";
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                          child: _isLoading ? CircularProgressIndicator(color: Colors.black, strokeWidth: 3.5) : Text('Register', style: TextStyle(color: Colors.white, fontSize: 16.0)),
                          onPressed: () {
                            _onRegister();
                          }
                      ),
                    ),
                    SizedBox(height: 25.0),
                    Text.rich(
                      TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignInPage()));
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0)),
                  ],
                ),
              ],
            ),
          )
      ),
    );
  }
}