import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MemberTile extends StatelessWidget {
  final String userName;
  final String groupName;

  MemberTile({required this.userName, required this.groupName});

  @override
  Widget build(BuildContext context) {
    int index = userName.indexOf("_");
    var rawUserName = userName.substring(index + 1).trim();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: ListTile(
        leading: ProfilePicture(
          radius: 30.0,
          name: '$rawUserName',
          fontsize: 21.sp,
        ),
        title: Text(rawUserName, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("You are a member of $groupName", style: TextStyle(fontSize: 13.0)),
      ),
    );
  }
}