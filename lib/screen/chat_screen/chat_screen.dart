import 'package:MayTeam/core/service/notification.dart';
import 'package:MayTeam/core/service/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/service/provider/auth.dart';
import '../../MAYteam/AdminPage.dart';
import '../../widget/tile/member_tile.dart';
import '../../widget/tile/message_tile.dart';

class ChatScreen extends StatefulWidget {
  final String groupID;
  final String userName;
  final String groupName;
  final String userToken;

  ChatScreen({required this.groupID, required this.userName, required this.groupName, required this.userToken});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
    Stream<QuerySnapshot>? _chats;
    QuerySnapshot? _groupMembers;
    TextEditingController messageEditingController = new TextEditingController();
    List userTokens = [];

    Widget _chatMessages() {
      return StreamBuilder <QuerySnapshot>(
        stream: _chats,
        builder: (context, snapshot) {
          return snapshot.hasData ? ListView.builder(
              physics: BouncingScrollPhysics(),
            reverse: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return MessageTile(
                  message: snapshot.data!.docs[snapshot.data!.docs.length - index - 1].get("message"),
                  sender: snapshot.data!.docs[snapshot.data!.docs.length - index - 1].get("sender"),
                  sentByMe: widget.userName == snapshot.data!.docs[snapshot.data!.docs.length - index - 1].get("sender"),
                  groupID: widget.groupID,
                  messageID: snapshot.data!.docs[snapshot.data!.docs.length - index - 1].id,
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
        FirebaseService.sendMessage(widget.groupID, chatMessageMap);
        FirebaseService.getChats(widget.groupID).then((Stream<QuerySnapshot> val) {
          setState(() {
            _chats = val;
            messageEditingController.text = "";
          });
        });

        for(int i = 0; i < userTokens.length; i++) {
          print('here');
          FCM().sendNotification(widget.userName, messageEditingController.text, userTokens[i]);
        }
      }
      FirebaseService.updateUserLastGroup(context.read<AutherProvider>().user!.uid, widget.groupName);
    }

    _getGroupMembers() async {
      FirebaseService.getGroupMembers(widget.groupID).then((QuerySnapshot val) {
        setState(() {
          _groupMembers = val;
        });
        setState(() {
        userTokens = _groupMembers!.docs[0].get('memberTokens');
        userTokens.remove(widget.userToken);
        });
      });
    }

    _deleteEmptyGroup() async {
      FirebaseService.getAllGroups().then((value) => value.forEach((element) {
        for(var i = 0; i < element.docs.length; i++) {
          List<dynamic> doc = element.docs.elementAt(i).get('members');
          if(doc.isEmpty) {
            print(i);
            FirebaseFirestore.instance.runTransaction((transaction) async => transaction.delete(FirebaseService.groupCollection.doc(element.docs.elementAt(i).id)));
          }
        }
      }));
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
          await FirebaseService.togglingGroupJoin(context.read<AutherProvider>().user!.uid, widget.groupID, widget.groupName, widget.userName, widget.userToken);
          if(context.read<AutherProvider>().user?.email == "taneri862@gmail.com") {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminPage()));
          }
          else {
            context.go('/');
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
            child: ListView.builder (
              itemCount: _groupMembers!.size,
              itemBuilder: (context, index) {
                if(_groupMembers!.docs[index].exists) {
                  var data = _groupMembers!.docs[index];
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
      FirebaseService.getChats(widget.groupID).then((Stream<QuerySnapshot> val) {
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
                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(80)),
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.5),
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