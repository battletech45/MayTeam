import 'package:MayTeam/screen/chat_screen/chat_screen.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatelessWidget {
  final String userName;
  final String groupID;
  final String groupName;
  final String userToken;

  GroupTile({required this.userName, required this.groupID, required this.groupName, required this.userToken});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(groupID: groupID, userName: userName, groupName: groupName, userToken: userToken)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.brown[900],
            child: Text(groupName.substring(0,1).toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
          ),
          title: Text(groupName, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("Join the chat room as $userName", style: TextStyle(fontSize: 13.0)),
        ),
      ),
    );
  }
}