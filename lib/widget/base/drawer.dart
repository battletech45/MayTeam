import 'package:MayTeam/core/constant/color.dart';
import 'package:MayTeam/core/service/provider/auth.dart';
import 'package:MayTeam/widget/tile/navigation_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      color: AppColor.primaryBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: UIConst.pageFullPadding(context),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ScaleButton(
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