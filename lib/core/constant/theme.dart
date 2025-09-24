import 'package:mayteam/core/constant/color.dart';
import 'package:mayteam/core/constant/text_style.dart';
import 'package:mayteam/core/constant/ui_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../util/navigation_transition.dart';

class AppTheme {
  AppTheme._();
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'NotoSans',
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(primary: AppColor.primaryBackgroundColor, secondary: AppColor.secondaryBackgroundColor),
    appBarTheme: const AppBarTheme(iconTheme: _iconTheme, backgroundColor: AppColor.primaryBackgroundColor),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: AppColor.primaryBackgroundColor, unselectedItemColor: AppColor.secondaryBackgroundColor),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: SlidingPageTransition(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
      }
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColor.red),
    indicatorColor: AppColor.brightBlue,
    inputDecorationTheme: _inputTheme,
    filledButtonTheme: filledButtonTheme,
    textButtonTheme: _textButtonTheme,
    cardTheme: _cardTheme,
    bottomSheetTheme: _bottomSheetTheme,
    dialogTheme: dialogTheme,
    datePickerTheme: _datePickerTheme,
    checkboxTheme: _checkboxThemeData,
    dividerTheme: _dividerThemeData,
    snackBarTheme: _snackBarThemeData,
    iconTheme: _iconTheme,
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: 'NotoSans',
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(primary: AppColor.primaryBackgroundColorDark, secondary: AppColor.secondaryBackgroundColorDark),
    appBarTheme: const AppBarTheme(iconTheme: _iconThemeDark, backgroundColor: AppColor.primaryBackgroundColorDark),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: AppColor.primaryBackgroundColorDark, unselectedItemColor: AppColor.secondaryBackgroundColorDark),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: SlidingPageTransition(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
      }
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColor.red),
    indicatorColor: AppColor.brightBlueDark,
    inputDecorationTheme: _inputThemeDark,
    filledButtonTheme: filledButtonTheme,
    textButtonTheme: _textButtonThemeDark,
    cardTheme: _cardThemeDark,
    bottomSheetTheme: _bottomSheetTheme,
    dialogTheme: dialogTheme,
    datePickerTheme: _datePickerTheme,
    checkboxTheme: _checkboxThemeData,
    dividerTheme: _dividerThemeDataDark,
    snackBarTheme: _snackBarThemeDataDark,
    iconTheme: _iconThemeDark
  );

  static const IconThemeData _iconTheme = IconThemeData(size: 20, color: AppColor.iconColor);
  static const IconThemeData _iconThemeDark = IconThemeData(size: 20, color: AppColor.iconColorDark);
  static const DividerThemeData _dividerThemeData = DividerThemeData(space: 0, color: AppColor.iconColor);
  static const DividerThemeData _dividerThemeDataDark = DividerThemeData(space: 0, color: AppColor.iconColorDark);
  static const CheckboxThemeData _checkboxThemeData = CheckboxThemeData(shape: CircleBorder());
  static const _datePickerTheme = DatePickerThemeData(surfaceTintColor: Colors.transparent);

  static final BottomSheetThemeData _bottomSheetTheme = BottomSheetThemeData(
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: const BorderRadius.vertical(top: Radius.circular(UIConst.radiusValue)).r),
    showDragHandle: true,
  );

  static DialogThemeData dialogTheme = DialogThemeData(
    shape: UIConst.rectangelBorder,
    surfaceTintColor: Colors.transparent,
  );

  static final _inputTheme = InputDecorationTheme(
    alignLabelWithHint: true,
    enabledBorder: _enabledBorder,
    focusedBorder: _focusedBorder,
    errorBorder: errorBorder,
    filled: true,
    fillColor: AppColor.primaryBackgroundColor,
    focusedErrorBorder: focusedErrorBorder,
    helperMaxLines: 1,
    errorMaxLines: 1,
    errorStyle: AppTextStyle.fieldError,
    hintStyle: AppTextStyle.fieldHint,
  );

  static final _inputThemeDark = InputDecorationTheme(
    alignLabelWithHint: true,
    enabledBorder: _enabledBorderDark,
    focusedBorder: _focusedBorderDark,
    errorBorder: errorBorder,
    filled: true,
    fillColor: AppColor.primaryTextColorDark,
    focusedErrorBorder: focusedErrorBorder,
    helperMaxLines: 1,
    errorMaxLines: 1,
    errorStyle: AppTextStyle.fieldError,
    hintStyle: AppTextStyle.fieldHint,
  );

  static final _cardTheme = CardThemeData(
    surfaceTintColor: Colors.transparent,
    color: AppColor.outgoingBubbleBackground,
    shape: UIConst.rectangelBorder.copyWith(side: const BorderSide(color: AppColor.borderColor, width: 1, style: BorderStyle.solid)),
    margin: EdgeInsets.zero,
    elevation: 0,
  );

  static final _cardThemeDark = CardThemeData(
    surfaceTintColor: Colors.transparent,
    color: AppColor.outgoingBubbleBackgroundDark,
    shape: UIConst.rectangelBorder,
    margin: EdgeInsets.zero,
    elevation: 0,
  );

  static final _snackBarThemeData = SnackBarThemeData(
    shape: UIConst.rectangelBorder,
    behavior: SnackBarBehavior.floating,
    showCloseIcon: true,
    backgroundColor: AppColor.outgoingBubbleBackground,
  );

  static final _snackBarThemeDataDark = SnackBarThemeData(
    shape: UIConst.rectangelBorder,
    behavior: SnackBarBehavior.floating,
    showCloseIcon: true,
    backgroundColor: AppColor.outgoingBubbleBackgroundDark,
  );

  static const _border = BorderSide(color: AppColor.borderColor);
  static const _borderDark = BorderSide(color: AppColor.borderColorDark);

  static final _enabledBorder = OutlineInputBorder(
    borderRadius: UIConst.cardBorderRadius,
    borderSide: _border,
  );

  static final _enabledBorderDark = OutlineInputBorder(
    borderRadius: UIConst.cardBorderRadius,
    borderSide: _borderDark,
  );

  static OutlineInputBorder errorBorder = OutlineInputBorder(
    borderRadius: UIConst.cardBorderRadius,
    borderSide: const BorderSide(width: 1.5, color: AppColor.red),
  );

  static OutlineInputBorder focusedErrorBorder = OutlineInputBorder(
    borderRadius: UIConst.cardBorderRadius,
    borderSide: const BorderSide(width: 2, color: AppColor.red),
  );

  static final _focusedBorder = OutlineInputBorder(
    borderRadius: UIConst.cardBorderRadius,
    borderSide: const BorderSide(width: 2, color: AppColor.borderColor),
  );

  static final _focusedBorderDark = OutlineInputBorder(
    borderRadius: UIConst.cardBorderRadius,
    borderSide: const BorderSide(width: 2, color: AppColor.borderColorDark),
  );

  static FilledButtonThemeData filledButtonTheme = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      foregroundColor: AppColor.primaryTextColor,
      shape: UIConst.rectangelBorder,
      textStyle: AppTextStyle.bigButtonText,
    ),
  );
  static final _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColor.primaryTextColor,
      shape: UIConst.rectangelBorder,
      textStyle: AppTextStyle.smallButtonText,
    ),
  );

  static final _textButtonThemeDark = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColor.primaryTextColorDark,
      shape: UIConst.rectangelBorder,
      textStyle: AppTextStyle.smallButtonText,
    ),
  );
}