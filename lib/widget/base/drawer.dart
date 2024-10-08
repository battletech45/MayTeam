import 'package:MayTeam/core/constant/color.dart';
import 'package:MayTeam/core/service/provider/auth.dart';
import 'package:MayTeam/core/service/provider/theme.dart';
import 'package:MayTeam/widget/tile/navigation_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constant/text_style.dart';
import '../../core/constant/ui_const.dart';
import '../button/scale_button.dart';

class AppDrawer extends StatelessWidget {
  final double width;
  final VoidCallback onWillCloseDrawer;

  const AppDrawer({super.key, required this.onWillCloseDrawer, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: UIConst.screenSize.height,
      child: SafeArea(
        child: Padding(
          padding: UIConst.pageFullPadding(context),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset('assets/images/logo.png', width: 200.w, height: 200.h, fit: BoxFit.cover),
                20.verticalSpace,
                ScaleButton(
                  decoration: BoxDecoration(
                      color: context.watch<ThemeProvider>().themeString == 'light' ? AppColor.primaryBackgroundColor : AppColor.secondaryBackgroundColorDark,
                      border: Border.all(
                        width: 1,
                        color: AppColor.secondaryBackgroundColor
                      )
                  ),
                  bordered: true,
                  onTap: () async {
                    onWillCloseDrawer();
                    await context.push('/profile');
                  },
                  child: const NavigationTile(leading: Icon(Icons.person), title: 'Profili Görüntüle'),
                ),
                20.verticalSpace,
                ScaleButton(
                  decoration: BoxDecoration(
                      color: context.watch<ThemeProvider>().themeString == 'light' ? AppColor.primaryBackgroundColor : AppColor.secondaryBackgroundColorDark,
                      border: Border.all(
                          width: 1,
                          color: AppColor.secondaryBackgroundColor
                      )
                  ),
                  bordered: true,
                  onTap: () async {
                    await FirebaseAuth.instance.sendPasswordResetEmail(email: context.read<AutherProvider>().user!.email ?? '');
                    await context.read<AutherProvider>().signOut();
                    context.go('/login');
                    Fluttertoast.showToast(msg: 'E-Posta Başarıyla Gönderildi !');
                    onWillCloseDrawer();
                  },
                  child: const NavigationTile(leading: Icon(Icons.person), title: 'Şifre Sıfırla'),
                ),
                20.verticalSpace,
                ScaleButton(
                  decoration: BoxDecoration(
                      color: context.watch<ThemeProvider>().themeString == 'light' ? AppColor.primaryBackgroundColor : AppColor.secondaryBackgroundColorDark,
                      border: Border.all(
                          width: 1,
                          color: AppColor.secondaryBackgroundColor
                      )
                  ),
                  bordered: true,
                  onTap: () async {
                    await context.read<AutherProvider>().signOut();
                    context.go('/login');
                  },
                  child: const NavigationTile(leading: Icon(Icons.logout), title: 'Çıkış Yap'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}