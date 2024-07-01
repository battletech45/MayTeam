import 'package:MayTeam/core/constant/text_style.dart';
import 'package:MayTeam/core/service/firebase.dart';
import 'package:MayTeam/core/util/extension.dart';
import 'package:MayTeam/widget/dialog/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constant/color.dart';
import '../../core/util/validator.dart';
import '../button/scale_button.dart';
import '../form/app_form_field.dart';

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

  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      messageController.text = widget.message;
    });
  }

  void _editMessage() {
    if(widget.sentByMe) {
      context.showAppDialog(
          AppAlertDialog(
            title: 'Düzenle',
            customIcon: Center(
              child: AppFormField(
                hintText: 'Mesajınız',
                controller: messageController,
                validator: AppValidator.passwordValidator,
                keyboardType: TextInputType.text,
                autofillHints: const [AutofillHints.name],
                textInputAction: TextInputAction.done,
              ),
            ),
            leftFunction: () {
              if(messageController.text.isEmpty) {
                FirebaseService.deleteMessage(widget.groupID!, widget.messageID!);
              }
              else {
                FirebaseService.editMessage(widget.groupID!, widget.messageID!, messageController.text);
              }
            },
            rightButtonText: 'Mesajı Sil',
            rightFunction: () {
              FirebaseService.deleteMessage(widget.groupID!, widget.messageID!);
            },
          )
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
            color: widget.sentByMe ? AppColor.outgoingBubbleBackground : AppColor.incomingBubbleBackground,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.sender.toUpperCase(), textAlign: TextAlign.start, style: AppTextStyle.messageSenderStyle),
              SizedBox(height: 7.h),
              Text(widget.message, textAlign: TextAlign.start, style: AppTextStyle.settingTile),
            ],
          ),
        ),
      ),
    );
  }
}