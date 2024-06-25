import 'package:MayTeam/core/constant/color.dart';
import 'package:MayTeam/core/constant/text_style.dart';
import 'package:MayTeam/core/constant/ui_const.dart';
import 'package:MayTeam/core/util/validator.dart';
import 'package:MayTeam/widget/button/loading_button.dart';
import 'package:MayTeam/widget/form/app_form_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../widget/base/scaffold.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /*
  _onSignIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await AuthService.signInWithEmailAndPassWord(email, password).then((
            result) async {
          if (_user.currentUser!.emailVerified) {
            if (result != null) {
              QuerySnapshot userInfoSnapshot = await FirebaseService.getUserData(email);

              if(userInfoSnapshot.docs[0].get('password') != password) {
                await FirebaseService.updateUserPassword(context.read<AutherProvider>().user!.uid, password);
              }
              token = await FirebaseMessaging.instance.getToken();
              if(userInfoSnapshot.docs[0].get('token') != token) {
                await FirebaseService.updateUserToken(context.read<AutherProvider>().user!.uid, token!);
              }
                context.go('/');
            }
            else {
              setState(() {
                error = 'Error signing in!';
                _isLoading = false;
              });
            }
          }
          else {
            _user.currentUser!.sendEmailVerification();
            context.go('/verification');
          }
        });
      }
      catch (e) {
        print(e);
        _showPopupDialog();
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

   */

  @override
  Widget build(BuildContext context) {
    return  AppScaffold(
      backgroundImage: false,
      backgroundColor: AppColor.secondaryBackgroundColor,
      child: Form(
          key: _formKey,
          child: Container(
            alignment: Alignment.center,
            padding: UIConst.pagePadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/logo.png', width: 175.w, height: 175.h),
                Text("Log In", style: AppTextStyle.dialogTitle),
                UIConst.verticalBlankSpace,
                AppFormField(
                  hintText: 'Email',
                  controller: emailController,
                  validator: AppValidator.emailValidator,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  textInputAction: TextInputAction.next,
                ),
                UIConst.verticalBlankSpace,
                AppFormField(
                  hintText: 'Password',
                  obscureText: true,
                  controller: passwordController,
                  validator: AppValidator.passwordValidator,
                  keyboardType: TextInputType.visiblePassword,
                  autofillHints: const [AutofillHints.password],
                  textInputAction: TextInputAction.done,
                ),
                UIConst.verticalBlankSpace,
                LoadingButton(
                  onTap: () async {},
                  backgroundColor: AppColor.red,
                  child: Text('Login'),
                ),
                UIConst.verticalBlankSpace,
                Text.rich(
                  TextSpan(
                    text: "Don't have an account ? ",
                    style: AppTextStyle.dialogText,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Click here',
                        style: AppTextStyle.dialogText.copyWith(decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = ()  {
                            context.go('/register');
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}