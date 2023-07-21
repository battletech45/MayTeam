import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:MayTeam/MAYteam/AdminPage.dart';
import 'package:MayTeam/MAYteam/Auth_functions.dart';
import 'package:MayTeam/MAYteam/Firebase_functions.dart';
import 'package:MayTeam/MAYteam/SideFunctions.dart';
import 'package:MayTeam/MAYteam/VerificationPage.dart';
import 'package:MayTeam/main.dart';
import 'ForgetPasswordPage.dart';
import 'GameGroupPage.dart';
import 'ResetPasswordPage.dart';

class SignInPage extends StatefulWidget {
  final Function? toggleView;
  SignInPage({this.toggleView});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _user = FirebaseAuth.instance;
  bool _isLoading = false;

  String email = '';
  String password = '';
  String error = '';

  void _showPopupDialog() {
    Widget okButton = MaterialButton(
      child: Text("OK"),
      color: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      splashColor: Colors.red[900],
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      icon: Icon(Icons.app_registration),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text("Email or password is wrong !"),
      content: Text('You entered wrong email or password. Please check.', textAlign: TextAlign.center),
      actions: <Widget>[okButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _onSignIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
      await _auth.signInWithEmailAndPassWord(email, password).then((
          result) async {
        if (_user.currentUser!.emailVerified) {
          if (result != null) {
            QuerySnapshot userInfoSnapshot = await FirebaseFunctions()
                .getUserData(email);

            await SideFunctions.saveUserLoggedInSharedPreference(true);
            await SideFunctions.saverUserEmailSharedPreference(email);
            await SideFunctions.saveUserNameSharedPreference(
                userInfoSnapshot.docs[0].get('fullName'));
            if(userInfoSnapshot.docs[0].get('password') != password) {
              await FirebaseFunctions(userID: _user.currentUser!.uid).updateUserPassword(password);
            }

            if (email == 'taneri862@gmail.com') {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AdminPage()));
            }
            else {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomePage()));
            }
          }
          else {
            setState(() {
              error = 'Error signing in!';
              _isLoading = false;
            });
          }
        }
        else {
          _user.currentUser!.sendEmailVerification();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => VerificationPage()));
          print("mail sent");
        }
      });
    }
    catch (e) {
        print(e);
        _showPopupDialog();
        setState(() {
          _isLoading = false;
        });
    }
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
          onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyApp())
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
                            .hasMatch(val!)
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
                      val!.length < 6
                          ?  val.length == 0 ? 'Please enter a valid password' : 'Password not strong enough'
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
                          child: _isLoading ? CircularProgressIndicator(color: Colors.black, strokeWidth: 3.5) : Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 16.0)),
                          onPressed: () {
                            _onSignIn();
                          }
                      ),
                    ),
                    SizedBox(height: 25.0),
                    Text.rich(
                      TextSpan(
                        text: "Forgot Password ? ",
                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Click here',
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline
                            ),
                            recognizer: TapGestureRecognizer()
                          ..onTap = ()  {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ResetPasswordPage()));
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