import 'dart:async';
import 'package:mayteam/core/constant/ui_const.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constant/color.dart';
import '../../core/constant/text_style.dart';

class AnimatedToggle extends StatelessWidget {
  final bool? current;
  final bool? first;
  final bool? second;
  final FutureOr<void>? Function(bool?) onChanged;
  final IconData leftIcon;
  final IconData? rightIcon;
  final String title;
  final String? leftText;
  final String? rightText;

  const AnimatedToggle(
      {super.key,
      this.current,
      this.first,
      this.second,
      required this.onChanged,
      required this.leftIcon,
      required this.title,
      this.rightIcon,
      this.leftText,
      this.rightText});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: UIConst.pagePadding,
      child: Column(
        children: <Widget>[
          Text(title, style: AppTextStyle.title),
          10.verticalSpace,
          AnimatedToggleSwitch.dual(
            style: const ToggleStyle(
                borderColor: AppColor.borderColor,
                boxShadow: const [
                  BoxShadow(
                      color: AppColor.primaryBackgroundColor,
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1.5))
                ]),
            iconBuilder: (val) => Icon(
              val! ? leftIcon : rightIcon ?? Icons.power_settings_new_rounded,
              size: 32.r,
              color: AppColor.primaryBackgroundColor,
            ),
            styleBuilder: (b) => ToggleStyle(
                backgroundColor: AppColor.primaryBackgroundColor,
                indicatorColor: b! ? AppColor.brightBlue : AppColor.red,
                borderRadius: BorderRadius.circular(50.r),
                indicatorBorderRadius: BorderRadius.circular(50.r)),
            height: 50.h,
            borderWidth: 5.0,
            current: current,
            first: first,
            second: second,
            onChanged: onChanged,
            textBuilder: (t) => Center(
              child: Text(t! ? leftText ?? 'Açık' : rightText ?? 'Kapalı',
                  style: AppTextStyle.description.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColor.primaryTextColor)),
            ),
          ),
        ],
      ),
    );
  }
}
