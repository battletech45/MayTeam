import 'package:MayTeam/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyle {
  AppTextStyle._();

  static TextStyle title = TextStyle(fontSize: 18.sp);
  static TextStyle defaultBlackText = const TextStyle();
  static TextStyle defaultWhiteText = const TextStyle();
  static TextStyle description = const TextStyle();
  static TextStyle subtitle = const TextStyle();

  static TextStyle bigButtonText = TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, fontFamily: 'Outfit');
  static TextStyle smallButtonText = TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, fontFamily: 'Outfit');

  static TextStyle dialogTitle = TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600);
  static TextStyle dialogText = TextStyle(fontSize: 14.sp);

  static TextStyle fieldText = TextStyle(fontSize: 11.sp);
  static TextStyle fieldHint = TextStyle(fontSize: 11.sp, color: AppColor.iconColor);
  static TextStyle fieldError = TextStyle(fontSize: 11.sp);
  static TextStyle fieldTitle = TextStyle(fontSize: 12.sp);
  static TextStyle formCardTitle = TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500, color: AppColor.secondaryTextColor);

  static TextStyle settingTile = TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500);
  static TextStyle messageSenderStyle = TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: -0.5);

  static TextStyle sliderChip = TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w300, color: AppColor.primaryBackgroundColor);
  static TextStyle sliderTitle = TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColor.primaryBackgroundColor);
  static TextStyle sliderDesc = TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300, color: AppColor.primaryBackgroundColor.withOpacity(0.9));

  static TextStyle mainSubtitle = TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle subtitleTextButton = TextStyle(fontSize: 13.sp, color: AppColor.primaryTextColor);

  static TextStyle smallCardTitle = TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500);
  static TextStyle smallCardDesc = TextStyle(fontSize: 8.sp, fontWeight: FontWeight.w300);

  static TextStyle drawerButton = TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500);

  static TextStyle textPageHeader = TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500, color: AppColor.primaryBackgroundColor);

  static TextStyle imagePageHeaderTitle = TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: AppColor.primaryBackgroundColor);
  static TextStyle imagePageHeaderDesc = TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300, color: AppColor.primaryBackgroundColor.withOpacity(0.8));

  static TextStyle blogText = TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w300);

  static TextStyle chipText = TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w300);

  static TextStyle notificationTitle = TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500);
  static TextStyle notificationDesc = TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w300, color: AppColor.iconColor.withOpacity(0.8));

  static TextStyle contactCardTitle = TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColor.primaryBackgroundColor);

  static TextStyle imageError = TextStyle(fontSize: 11.sp, color: AppColor.red);
  static TextStyle imageErrorCode = TextStyle(fontSize: 11.sp, color: AppColor.iconColor);
}
