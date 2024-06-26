import 'package:MayTeam/core/constant/color.dart';
import 'package:MayTeam/core/constant/text_style.dart';
import 'package:MayTeam/core/constant/ui_const.dart';
import 'package:MayTeam/core/service/notification.dart';
import 'package:MayTeam/core/service/firebase.dart';
import 'package:MayTeam/widget/base/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/service/provider/auth.dart';
import '../../widget/base/scaffold.dart';
import '../../widget/tile/member_tile.dart';
import '../../widget/tile/message_tile.dart';

class ChatScreen extends StatefulWidget {
  final String groupID;
  final String groupName;

  const ChatScreen({super.key, required this.groupID, required this.groupName});

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
                  sentByMe:context.read<AutherProvider>().user!.displayName == snapshot.data!.docs[snapshot.data!.docs.length - index - 1].get("sender"),
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
          "sender": context.read<AutherProvider>().user!.displayName,
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
          FCM().sendNotification(context.read<AutherProvider>().user!.displayName ?? '', messageEditingController.text, userTokens[i]);
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
        userTokens.remove(context.read<AutherProvider>().user!.refreshToken);
        });
      });
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
          await FirebaseService.togglingGroupJoin(context.read<AutherProvider>().user!.uid, widget.groupID, widget.groupName, context.read<AutherProvider>().user!.displayName ?? '', context.read<AutherProvider>().user!.refreshToken ?? '');
          context.go('/');
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
                  if (data['members'] != null) {
                    if (data['members'].length != 0) {
                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: data['members'].length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            int reqIndex = data['members'].length - index - 1;
                            return MemberTile(
                                userName: data['members'][reqIndex],
                                groupName: widget.groupName);
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
      return AppScaffold(
        backgroundImage: false,
        backgroundColor: AppColor.primaryBackgroundColor,
        appBar: AppAppBar(
          isDrawer: false,
          title: widget.groupName,
          actions: [
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: (){}
            )
          ],
        ),
        child: Column(
          children: <Widget>[
            Expanded(
                child: _chatMessages()
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              margin: UIConst.inputTopMargin,
              padding: (UIConst.pagePadding) / 2 + (UIConst.pageScrollPadding(context) * 0.75),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onSubmitted: _sendMessage(),
                      controller: messageEditingController,
                      decoration: InputDecoration(
                          hintText: 'Send a message...',
                          hintStyle: AppTextStyle.mainSubtitle,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColor.borderColor,
                              width: 2.0
                            ),
                            borderRadius: BorderRadius.circular(25.r)
                          )
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
                      child: Center(child: Icon(Icons.send)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }