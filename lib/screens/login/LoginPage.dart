import 'package:MayTeam/screens/login/login_page_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:MayTeam/MAYteam/AdminPage.dart';
import 'package:MayTeam/MAYteam/Auth_functions.dart';
import 'package:MayTeam/MAYteam/Firebase_functions.dart';
import 'package:MayTeam/MAYteam/SideFunctions.dart';
import 'package:MayTeam/MAYteam/VerificationPage.dart';
import 'package:MayTeam/main.dart';
import 'package:get/get.dart';
import '../../MAYteam/GameGroupPage.dart';
import '../../MAYteam/ResetPasswordPage.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginPageController controller = Get.put(LoginPageController());
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.brown[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
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
                  controller: controller.emailController,
                  decoration: InputDecoration(hintText: 'EMAIL'),
                  style: TextStyle(color: Colors.white),
                  validator: (val) {
                    return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val!)
                        ? null
                        : "Please enter a valid email";
                  },
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  decoration: InputDecoration(hintText: 'PASSWORD'),
                  controller: controller.passwordController,
                  style: TextStyle(color: Colors.white),
                  validator: (val) => val!.length < 6
                      ? val.length == 0
                          ? 'Please enter a valid password'
                          : 'Password not strong enough'
                      : null,
                  obscureText: true,
                ),
                SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: Obx(() {
                    return MaterialButton(
                        elevation: 0.0,
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        child: controller.signInProgress.value
                            ? CircularProgressIndicator(
                                color: Colors.black, strokeWidth: 3.5)
                            : Text('Sign In',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0)),
                        onPressed: () => controller.onSignIn());
                  }),
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
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(ResetPasswordPage());
                          },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
