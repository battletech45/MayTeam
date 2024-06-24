import 'package:MayTeam/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/service/device_service.dart';
import '../../core/service/provider/auth.dart';
import '../../widget/animation/animated_logo.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) {
      if(context.read<AutherProvider>().isAuth) {
        context.go('/');
      }
      else {
        context.go('/login');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    if(DeviceService.isInit == false) {
      DeviceService.init(context);
    }
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColor.secondary,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: AppColor.secondary
          ),
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