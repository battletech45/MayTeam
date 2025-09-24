import 'package:mayteam/core/service/provider/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/util/validator.dart';
import '../../widget/form/app_form_field.dart';

class ForgetPasswordScreen extends StatefulWidget {

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {

  final TextEditingController oldController = TextEditingController();
  final TextEditingController newController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _resetPassword(String oldPassword, String newPassword) async {
    setState(() {
      _isLoading = true;
    });
    final _credential = EmailAuthProvider.credential(email: context.read<AutherProvider>().user!.email!, password: oldPassword);
    await context.read<AutherProvider>().user!.reauthenticateWithCredential(_credential);
    await context.read<AutherProvider>().user!.updatePassword(newPassword);
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
                  AppFormField(
                    hintText: 'Old Password',
                    obscureText: true,
                    controller: oldController,
                    validator: AppValidator.passwordValidator,
                    keyboardType: TextInputType.visiblePassword,
                    autofillHints: const [AutofillHints.password],
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 30.0),
                  AppFormField(
                    hintText: 'New Password',
                    obscureText: true,
                    controller: newController,
                    validator: AppValidator.passwordValidator,
                    keyboardType: TextInputType.visiblePassword,
                    autofillHints: const [AutofillHints.password],
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 30.0),
                  MaterialButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                      color: Colors.red,
                      child: _isLoading ? CircularProgressIndicator(color: Colors.black, strokeWidth: 3.5) : Text('Reset Password'),
                      onPressed: () {
                        _resetPassword(oldController.text, newController.text);
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