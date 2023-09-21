import 'package:MayTeam/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MayTeam/MAYteam/Auth_functions.dart';
import 'package:MayTeam/MAYteam/Firebase_functions.dart';
import 'package:MayTeam/MAYteam/SideFunctions.dart';

class LoginPageController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool signInProgress = false.obs;

  void onSignIn() async {
    signInProgress.value = true;
    String email = emailController.text;
    String password = passwordController.text;
    ModelUser user =
        await AuthService.instance.signInWithEmailAndPassword(email, password);
    if (user.userID != "") {
      signInProgress.value = false;
      //success
      if (await FirebaseFunctions.instance.isUserAdmin(email)) {
        //user admin
        Get.toNamed(Routes.admin);
      } else {
        //normal user
        Get.toNamed(Routes.home);
      }
    } else {
      signInProgress.value = false;
      Get.rawSnackbar(
        snackPosition: SnackPosition.TOP,
        maxWidth: 270,
        backgroundColor: Colors.red,
        borderRadius: 20,
        duration: const Duration(milliseconds: 1200),
        messageText: Center(
          child: Text("signin failed"),
        ),
      );
      //fail
    }
  }
}
