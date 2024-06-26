import 'package:MayTeam/core/constant/color.dart';
import 'package:MayTeam/core/service/provider/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constant/text_style.dart';
import '../../core/constant/ui_const.dart';

class AppDrawer extends StatelessWidget {
  final double width;
  final VoidCallback onWillCloseDrawer;

  const AppDrawer({super.key, required this.onWillCloseDrawer, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: AppColor.secondaryBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: UIConst.pageFullPadding(context),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DrawerButton(
                  title: 'Çıkış Yap',
                  onTap: () async {
                    await context.read<AutherProvider>().signOut();
                    context.go('/login');
                  },
                )
              ],
            ),
          ),
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
