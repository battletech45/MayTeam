import 'package:MayTeam/core/constant/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constant/color.dart';

class ProfileTile extends StatelessWidget {
  final String data;
  final IconData icon;

  const ProfileTile({super.key, required this.icon, required this.data});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(border: Border.all(color: AppColor.primaryTextColor, width: 1.0), borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 25.r),
          10.horizontalSpace,
          Text("$data", style: AppTextStyle.bigButtonText),
        ],
      ),
    );
  }
}