import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constant/color.dart';

class AppDrawer extends StatelessWidget {
  final VoidCallback onWillCloseDrawer;
  const AppDrawer({super.key, required this.onWillCloseDrawer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            40.verticalSpace,
            SizedBox.square(dimension: 100, child: Image.asset('assets/images/logo.png')),
            40.verticalSpace,
          ],
        ),
      ),
    );
  }
}
