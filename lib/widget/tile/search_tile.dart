import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchTile extends StatelessWidget {
  final String groupName;
  final String admin;
  final VoidCallback onTap;

  const SearchTile({super.key, required this.groupName, required this.admin, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      leading: ProfilePicture(
        name: '$groupName',
        radius: 30.r,
        fontsize: 21.sp,
        random: true,
      ),
      title: Text(groupName, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("Admin: $admin"),
      onTap: onTap,
      trailing: Icon(Icons.add_circle_outline, size: 30.r),
    );
  }
}