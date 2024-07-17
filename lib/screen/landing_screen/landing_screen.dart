import 'dart:io';

import 'package:MayTeam/core/constant/color.dart';
import 'package:MayTeam/core/service/log.dart';
import 'package:MayTeam/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/service/device_service.dart';
import '../../core/service/provider/auth.dart';
import '../../widget/animation/animated_logo.dart';

String? fcmToken;
String? apnsToken;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage  message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> with SingleTickerProviderStateMixin  {

  @override
  void initState() {
    super.initState();
    try {
      initApp();
    }
    catch (e) {
      LoggerService.logError(e.toString());
    }
  }

  void initApp() async {
    await initFirebaseMessage();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) {
      if(context.read<AutherProvider>().isAuth) {
        if(context.read<AutherProvider>().user!.emailVerified) {
          context.go('/');
        }
        else {
          context.go('/verify');
        }
      }
      else {
        context.go('/login');
      }
    });
  }

  Future<void> initFirebaseMessage() async {
    var messaging = FirebaseMessaging.instance;
    if(Platform.isIOS) {
      LoggerService.logInfo('APNS TOKEN: $apnsToken');
      apnsToken = await messaging.getAPNSToken();
      LoggerService.logInfo('APNS TOKEN: $apnsToken');
      await Future.delayed(const Duration(seconds: 5));
    }
    fcmToken = await messaging.getToken();
    print(fcmToken);

    await messaging.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    if(DeviceService.isInit == false) {
      DeviceService.init(context);
    }
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedLogo(),
            ],
          ),
        ),
      ),
    );
  }
}