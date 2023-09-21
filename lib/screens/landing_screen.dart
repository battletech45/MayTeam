import 'package:MayTeam/screens/login/LoginPage.dart';
import 'package:MayTeam/MAYteam/SignUpPage.dart';
import 'package:MayTeam/constants/routes.dart';
import 'package:MayTeam/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        alignment: Alignment.center,
        color: Colors.brown[900],
        child:
            new Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('images/logo.png', width: 200, height: 200),
          SizedBox(height: 20.0),
          CustomButton(
              label: 'LOG IN',
              color: Colors.red,
              width: 120,
              height: 40,
              borderRadius: 25,
              onTap: () {
                Get.toNamed(Routes.login);
              },
              isDisable: false),
          SizedBox(
            height: 10,
          ),
          CustomButton(
              label: 'SIGN UP',
              color: Colors.black,
              width: 120,
              height: 40,
              borderRadius: 25,
              onTap: () {
                Get.toNamed(Routes.register);
              },
              isDisable: false),
        ]),
      ),
    );
  }
}
