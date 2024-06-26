import 'package:MayTeam/core/util/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UIConst {
  UIConst._();

  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration pageTransitionDuration = Duration(milliseconds: 400);

  static const double paddingValue = 20;

  static const double radiusValue = 6;
  static Radius radius = const Radius.circular(radiusValue).r;
  static BorderRadius cardBorderRadius = BorderRadius.circular(radiusValue).r;
  static RoundedRectangleBorder rectangelBorder = RoundedRectangleBorder(borderRadius: cardBorderRadius);

  static SizedBox verticalBlankSpace = 21.vb;
  static SizedBox horizontalBlankSpace = 12.hb;

  static EdgeInsets pagePadding = const EdgeInsets.symmetric(horizontal: paddingValue).r;
  static EdgeInsets inputTopMargin = const EdgeInsets.only(top: 5).r;
  static EdgeInsets pageScrollPadding(BuildContext context) => EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + paddingValue).r;

  static EdgeInsets pageFullPadding(BuildContext context) =>
      EdgeInsets.only(left: paddingValue, right: paddingValue, top: paddingValue, bottom: MediaQuery.of(context).padding.bottom + paddingValue).r;
}
