import 'package:flutter/material.dart';

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
        leading: CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.brown[900],
          child: Text(rawUserName.substring(0,1).toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
        ),
        title: Text(rawUserName, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("You are a member of $groupName", style: TextStyle(fontSize: 13.0)),
      ),
    );
  }
}