import 'package:MayTeam/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../core/service/device_service.dart';
import '../../widget/animation/animated_logo.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    if(DeviceService.isInit == false) {
      DeviceService.init(context);
    }
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColor.primary,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: AppColor.primary
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