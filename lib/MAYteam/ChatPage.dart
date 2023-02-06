import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:MayTeam/MAYteam/Chat_Group_Settings.dart';
import 'package:MayTeam/MAYteam/Chat_Message_Settings.dart';
import 'AdminPage.dart';
import 'Firebase_functions.dart';
import 'GameGroupPage.dart';

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
    Stream<DocumentSnapshot> _groupMembers;
    TextEditingController messageEditingController = new TextEditingController();
    User _user;

    Widget _chatMessages() {
      return StreamBuilder <QuerySnapshot>(
        stream: _chats,
        builder: (context, snapshot) {
          return snapshot.hasData ? ListView.builder(
              physics: BouncingScrollPhysics(),
            reverse: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return MessageTile(
                  message: snapshot.data.docs[snapshot.data.docs.length - index - 1].get("message"),
                  sender: snapshot.data.docs[snapshot.data.docs.length - index - 1].get("sender"),
                  sentByMe: widget.userName == snapshot.data.docs[snapshot.data.docs.length - index - 1].get("sender"),
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
        FirebaseFunctions().getChats(widget.groupID).then((Stream<QuerySnapshot> val) {
          setState(() {
            _chats = val;
            messageEditingController.text = "";
          });
        });
      }
      FirebaseFunctions(userID: _user.uid).updateUserLastGroup(widget.groupName);
    }

    _getGroupMembers() async {
      FirebaseFunctions().getGroupMembers(widget.groupID).then((Stream<DocumentSnapshot> val) {
        setState(() {
          _groupMembers = val;
        });
      });
      _user = FirebaseAuth.instance.currentUser;
    }

    void _popupGroupMemberLists(BuildContext context) {
      Widget backButton = MaterialButton(
        child: Text("Back"),
        elevation: 5.0,
        color: Colors.red[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        splashColor: Colors.black,
        onPressed:  () {
          Navigator.of(context).pop();
        },
      );

      Widget leaveButton = MaterialButton(
        child: Text("Leave Group"),
        elevation: 5.0,
        color: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        splashColor: Colors.red[900],
        onPressed: () async {
          await FirebaseFunctions(userID: _user.uid).togglingGroupJoin(widget.groupID, widget.groupName, widget.userName);
          if(_user.email == "taneri862@gmail.com") {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminPage()));
          }
          else {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
          }
        },
      );

      AlertDialog alert = AlertDialog(
        icon: Icon(Icons.people_alt),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text("Group Members"),
        actions: [backButton, leaveButton],
        content: Material(
          elevation: 10.0,
          child: Container(
            height: 225.0,
            width:  200.0,
            child: StreamBuilder <DocumentSnapshot> (
              stream: _groupMembers,
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if(snapshot.hasData) {
                  var data = snapshot.data;
                  if(data['members'] != null) {
                    if(data['members'].length != 0) {
                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: data['members'].length,
                          shrinkWrap: true,
                          itemBuilder:  (context, index) {
                            int reqIndex = data['members'].length - index - 1;
                            return MemberTile(userName: data['members'][reqIndex], groupName: widget.groupName);
                          }
                      );
                    }
                    else {
                      return CircularProgressIndicator();
                    }
                  }
                  else {
                    return CircularProgressIndicator();
                  }
                }
                else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        )
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    @override
    void initState() {
      super.initState();
      _getGroupMembers();
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
          title: Text(widget.groupName, style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.brown[900],
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info_outline_rounded, color: Colors.white),
              onPressed: () {
                _popupGroupMemberLists(context);
              },
            ),
          ],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                  child: _chatMessages()
              ),
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
                          onSubmitted: _sendMessage(),
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
              ),
            ],
          ),
        ),
      );
    }
  }