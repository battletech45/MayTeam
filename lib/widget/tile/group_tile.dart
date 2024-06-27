import 'package:MayTeam/screen/chat_screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class GroupTile extends StatelessWidget {
  final String userName;
  final String groupID;
  final String groupName;

  GroupTile({required this.userName, required this.groupID, required this.groupName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/chat/${groupID}', extra: groupName);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: ListTile(
          leading: ProfilePicture(
            name: '$groupName',
            radius: 30.r,
            fontsize: 21.sp,
          ),
          title: Text(groupName, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("Join the chat room as $userName", style: TextStyle(fontSize: 13.0)),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}