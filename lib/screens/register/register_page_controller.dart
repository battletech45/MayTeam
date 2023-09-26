import 'package:MayTeam/MAYteam/Firebase_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../MAYteam/Auth_functions.dart';
import '../../constants/routes.dart';

class RegisterPageController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool registerInProgress = false.obs;
  RxBool userNameUnique = false.obs;

  final AuthService _auth = AuthService();
  final formKey = GlobalKey<FormState>();
  final _user = FirebaseAuth.instance;

  String? token;

  onRegister() async {
    registerInProgress.value = true;
    userNameUnique.value = await FirebaseFunctions().checkUserNameExistence(nameController.text);
    if (formKey.currentState!.validate()) {
      if (userNameUnique.value) {
        token = await FirebaseMessaging.instance.getToken();
        await _auth
            .registerWithEmailAndPassword(
            nameController.text, emailController.text, passwordController.text, token!, false)
            .then((result) async {
          if (_user.currentUser!.emailVerified) {
            if (result != null) {
              Get.toNamed(Routes.home);
            } else {
              Get.rawSnackbar(
                snackPosition: SnackPosition.TOP,
                maxWidth: 270,
                backgroundColor: Colors.red,
                borderRadius: 20,
                duration: const Duration(milliseconds: 1200),
                messageText: Center(
                  child: Text("Register failed"),
                ),
              );
            }
          } else {
            _user.currentUser!.sendEmailVerification();
            Get.toNamed(Routes.verification);
          }
        });
      } else {
        Get.rawSnackbar(
          snackPosition: SnackPosition.TOP,
          maxWidth: 270,
          backgroundColor: Colors.red,
          borderRadius: 20,
          duration: const Duration(milliseconds: 1200),
          messageText: Center(
            child: Text("User name is taken. Please select a new user name."),
          ),
        );
      }
    }
  }

}