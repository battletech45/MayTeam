import 'package:mayteam/core/constant/text_style.dart';
import 'package:mayteam/core/constant/ui_const.dart';
import 'package:mayteam/core/service/provider/auth.dart';
import 'package:mayteam/core/util/extension.dart';
import 'package:mayteam/widget/base/scaffold.dart';
import 'package:mayteam/widget/dialog/alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constant/color.dart';
import '../../widget/button/loading_button.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});
  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {

  Future<void> _getVerificationValue() async {
    await context.read<AutherProvider>().user?.reload();
    User? user = context.read<AutherProvider>().user;

    if(user != null) {
     if(user.emailVerified) {
       context.go('/');
     }
     else {
       context.showAppDialog(
           AppAlertDialog(
             title: 'Hata !',
             text: 'Lütfen Mail Kutunuzu Kontrol Edin !',
             isSingleButton: true,
             type: AlertType.warn,
           )
       );
     }
    }
    else {
      context.showAppDialog(
        AppAlertDialog(
          title: 'Hata !',
          text: "E-Posta'nız onaylanmamıştır. Lütfen Posta kutunuzu kontrol ediniz.",
          isSingleButton: true,
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundImage: false,
      child: Padding(
        padding: UIConst.pagePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.email_outlined, size: 100.0),
            UIConst.verticalGap(),
            Text('Mail Kutunuzu Kontrol Edin !', style: AppTextStyle.dialogTitle),
            UIConst.verticalGap(),
            LoadingButton(
              onTap: _getVerificationValue,
              backgroundColor: AppColor.red,
              child: Text('Kontrol Et'),
            )
          ],
        ),
      ),
    );
  }
}
