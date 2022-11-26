import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/MAYteam/Chat_Message_Settings.dart';
import 'Firebase_functions.dart';

class ChatPage extends StatefulWidget {
  final String groupID;
  final String userName;
  final String groupName;

  ChatPage({this.groupID, this.userName, this.groupName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
    Stream<QuerySnapshot> _chats;
    TextEditingController messageEditingController = new TextEditingController();

    Widget _chatMessages() {
      return StreamBuilder <QuerySnapshot>(
        stream: _chats,
        builder: (context, snapshot) {
          return snapshot.hasData ? ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return MessageTile(
                  message: snapshot.data.docs[index].get("message"),
                  sender: snapshot.data.docs[index].get("sender"),
                  sentByMe: widget.userName == snapshot.data.docs[index].get("sender"),
                );
              }
          ) : Container();
        },
      );
    }

    _sendMessage() {
      if (messageEditingController.text.isNotEmpty) {
        Map<String, dynamic> chatMessageMap = {
          "message": messageEditingController.text,
          "sender": widget.userName,
          'time': DateTime
              .now()
              .millisecondsSinceEpoch,
        };

        FirebaseFunctions().sendMessage(widget.groupID, chatMessageMap);

        setState(() {
          messageEditingController.text = "";
        });
      }
    }

    @override
    void initState() {
      super.initState();
      FirebaseFunctions().getChats(widget.groupID).then((Stream<QuerySnapshot> val) {
        setState(() {
          _chats = val;
        });
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          title: Text(widget.groupName, style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.brown[900],
          elevation: 0.0,
        ),
        body: Container(
          child: Stack(
            children: <Widget>[
              _chatMessages(),
              Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(80)),
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: messageEditingController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: 'Send a message...',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              border: InputBorder.none
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _sendMessage();
                        },
                        child: Container(
                          height: 50.0,
                          width: 50.0,
                          decoration: BoxDecoration(
                              color: Colors.brown[700],
                              borderRadius: BorderRadius.circular(50)
                          ),
                          child: Center(child: Icon(Icons.send, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }