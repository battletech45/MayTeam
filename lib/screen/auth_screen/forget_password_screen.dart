import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/service/firebase.dart';
import '../../core/service/provider/auth.dart';

class ForgetPasswordScreen extends StatefulWidget {

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {

  final _formKey = GlobalKey<FormState>();
  String _newPassword = '';
  String _oldPassword = '';
  bool _isLoading = false;
  final _user = FirebaseAuth.instance;

  void _resetPassword(String oldPassword, String newPassword) async {
    setState(() {
      _isLoading = true;
    });
    final _credential = EmailAuthProvider.credential(email: _user.currentUser!.email!, password: oldPassword);
    await _user.currentUser?.reauthenticateWithCredential(_credential);
    await _user.currentUser?.updatePassword(newPassword);
    await FirebaseService.updateUserPassword(context.read<AutherProvider>().user!.uid, newPassword);
    setState(() {
      _isLoading = false;
    });
    _showPopupDialog();
  }

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
      icon: Icon(Icons.key_outlined),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text("Changed password successfully !"),
      actions: <Widget>[okButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 50.0),
                  Text('Forget Password', style: TextStyle(color: Colors.white, fontSize: 25.0)),
                  SizedBox(height: 30.0),
                  Icon(Icons.key, size: 100.0),
                  SizedBox(height: 30.0),
                  Text('Please enter your new password here.', style: TextStyle(color: Colors.white, fontSize: 15.0)),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: 'OLD PASSWORD'
                    ),
                    style: TextStyle(color: Colors.white),
                    obscureText: true,
                    validator: (val) {
                      if(val!.length == 0) {
                        return 'Please enter a valid password';
                      }
                      else {
                        if(val.length < 6) {
                          return 'Please enter stronger password';
                        }
                        return null;
                      }
                    },
                    onChanged: (val) {
                      setState(() {
                        _oldPassword = val;
                      });
                    },
                  ),
                  SizedBox(height: 30.0),
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: 'NEW PASSWORD'
                    ),
                    style: TextStyle(color: Colors.white),
                    obscureText: true,
                    validator: (val) {
                      if(val!.length == 0) {
                        return 'Please enter a valid password';
                      }
                      else {
                        if(val.length < 6) {
                          return 'Please enter stronger password';
                        }
                        return null;
                      }
                    },
                    onChanged: (val) {
                      setState(() {
                        _newPassword = val;
                      });
                    },
                  ),
                  SizedBox(height: 30.0),
                  MaterialButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                      color: Colors.red,
                      child: _isLoading ? CircularProgressIndicator(color: Colors.black, strokeWidth: 3.5) : Text('Reset Password'),
                      onPressed: () {
                        _resetPassword(_oldPassword, _newPassword);
                      }
                  ),
                  MaterialButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                      color: Colors.black,
                      child: Text('Back'),
                      onPressed: () => {
                        context.go('/')
                      }
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}