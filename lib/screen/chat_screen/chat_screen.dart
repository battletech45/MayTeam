import 'package:mayteam/core/constant/color.dart';
import 'package:mayteam/core/constant/text_style.dart';
import 'package:mayteam/core/constant/ui_const.dart';
import 'package:mayteam/core/service/firebase.dart';
import 'package:mayteam/core/service/provider/theme.dart';
import 'package:mayteam/core/util/extension.dart';
import 'package:mayteam/widget/base/appbar.dart';
import 'package:mayteam/widget/dialog/alert_dialog.dart';
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
  final TextEditingController messageEditingController = TextEditingController();
  Stream<QuerySnapshot>? _chats;
  DocumentSnapshot? _groupMembers;

  Widget _chatMessages() {
    return StreamBuilder<QuerySnapshot>(
      stream: _chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                reverse: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot
                        .data!.docs[snapshot.data!.docs.length - index - 1]
                        .get("message"),
                    sender: snapshot
                        .data!.docs[snapshot.data!.docs.length - index - 1]
                        .get("sender"),
                    sentByMe:
                        context.read<AutherProvider>().user!.displayName ==
                            snapshot.data!
                                .docs[snapshot.data!.docs.length - index - 1]
                                .get("sender"),
                    groupID: widget.groupID,
                    messageID: snapshot
                        .data!.docs[snapshot.data!.docs.length - index - 1].id,
                  );
                })
            : Container();
      },
    );
  }

  _sendMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageEditingController.text,
        "sender": context.read<AutherProvider>().user!.displayName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      FirebaseService.sendMessage(widget.groupID, chatMessageMap);
      FirebaseService.getChats(widget.groupID)
          .then((Stream<QuerySnapshot> val) {
        setState(() {
          _chats = val;
          messageEditingController.text = "";
        });
      });
    }
  }

  _getGroupMembers() async {
    FirebaseService.getGroupData(widget.groupID).then((DocumentSnapshot val) {
      setState(() {
        _groupMembers = val;
      });
    });
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
      resizeToAvoidBottomInset: true,
      appBar: AppAppBar(
        isDrawer: false,
        title: widget.groupName,
        actions: [
          IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                context.showAppDialog(AppAlertDialog(
                  title: 'Üye Listesi',
                  rightButtonText: 'Gruptan ayrıl',
                  leftButtonText: 'Kapat',
                  rightFunction: () async {
                    await FirebaseService.togglingGroupJoin(
                        context.read<AutherProvider>().user!.uid,
                        widget.groupID,
                        context.read<AutherProvider>().user!.displayName ?? '',
                        widget.groupName);
                    context.go('/');
                  },
                  customIcon: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: _groupMembers?.get('members').length ?? 0,
                    itemBuilder: (context, index) {
                      return MemberTile(
                          userName: _groupMembers!.get('members')[index],
                          groupName: widget.groupName);
                    },
                  ),
                ));
              })
        ],
      ),
      child: Column(
        children: <Widget>[
          Expanded(child: _chatMessages()),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            margin: UIConst.inputTopMargin,
            padding: (UIConst.pagePadding) / 2 +
                (UIConst.pageScrollPadding(context) * 0.75),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    onSubmitted: _sendMessage(),
                    controller: messageEditingController,
                    decoration: InputDecoration(
                        fillColor:
                            context.read<ThemeProvider>().themeString == 'light'
                                ? Colors.transparent
                                : AppColor.primaryBackgroundColorDark,
                        hintText: 'Send a message...',
                        hintStyle: AppTextStyle.mainSubtitle,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                            borderRadius: BorderRadius.circular(25.r))),
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
