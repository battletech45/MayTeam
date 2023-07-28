import 'package:MayTeam/MAYteam/Firebase_functions.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {

  final String message;
  final String sender;
  final bool sentByMe;
  final String? groupID;
  final String? messageID;

  MessageTile({required this.message, required this.sender, required this.sentByMe, this.groupID, this.messageID});

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {

  String? newMessage;

  void _editMessage() {
    if(widget.sentByMe) {
      Widget okButton = MaterialButton(
        child: Text("OK"),
        color: Colors.red[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        splashColor: Colors.black,
        onPressed: () {
          if(newMessage == null) {
            FirebaseFunctions().editMessage(widget.groupID!, widget.messageID!, widget.message);
            Navigator.of(context).pop();
          }
          else {
            FirebaseFunctions().editMessage(widget.groupID!, widget.messageID!, newMessage!);
            Navigator.of(context).pop();
          }
        },
      );
      Widget delButton = MaterialButton(
        child: Text("DELETE"),
        color: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        splashColor: Colors.red[900],
        onPressed: () {
         FirebaseFunctions().deleteMessage(widget.groupID!, widget.messageID!);
         Navigator.of(context).pop();
        },
      );

      AlertDialog alert = AlertDialog(
        icon: Icon(Icons.edit),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text('Please edit your message'),
        content: TextFormField(
            initialValue: widget.message,
            onChanged: (val) {
              newMessage = val;
            },
            style: TextStyle(
                fontSize: 15.0,
                height: 2.0,
                color: Colors.black
            )
        ),
        actions: <Widget>[delButton, okButton],
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _editMessage(),
      child: Container(
        padding: EdgeInsets.only(top: 4, bottom: 4, left: widget.sentByMe ? 0 : 24, right: widget.sentByMe ? 24: 0),
        alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: widget.sentByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
          padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
          decoration: BoxDecoration(
            borderRadius: widget.sentByMe ? BorderRadius.only(topLeft: Radius.circular(23), topRight: Radius.circular(23), bottomLeft: Radius.circular(23))
                :
                BorderRadius.only(topLeft: Radius.circular(23), topRight: Radius.circular(23), bottomRight: Radius.circular(23)
                ),
            color: widget.sentByMe ? Colors.teal[900] : Colors.blueGrey[700],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.sender.toUpperCase(), textAlign: TextAlign.start, style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: -0.5)),
              SizedBox(height: 7.0),
              Text(widget.message, textAlign: TextAlign.start, style: TextStyle(fontSize: 15.0, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}