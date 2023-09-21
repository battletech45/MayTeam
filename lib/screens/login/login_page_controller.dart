import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MayTeam/MAYteam/Auth_functions.dart';
import 'package:MayTeam/MAYteam/Firebase_functions.dart';
import 'package:MayTeam/MAYteam/SideFunctions.dart';

class AuthController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxString emailText = "".obs;
  RxString passwordtext = "".obs;
}
