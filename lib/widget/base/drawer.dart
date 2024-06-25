import 'package:MayTeam/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constant/text_style.dart';
import '../../core/constant/ui_const.dart';

class AppDrawer extends StatelessWidget {
  final VoidCallback onWillCloseDrawer;

  const AppDrawer({super.key, required this.onWillCloseDrawer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: AppColor.secondaryBackgroundColor,
      shape: const RoundedRectangleBorder(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

          ],
        ),
      ),
    );
  }
}

class DrawerButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final bool isSelected;
  const DrawerButton({
    super.key,
    this.onTap,
    required this.title,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: UIConst.cardBorderRadius,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5).r,
        child: Text(title, style: AppTextStyle.drawerButton.copyWith(color: isSelected ? AppColor.primaryTextColor : null)),
      ),
    );
  }
}
