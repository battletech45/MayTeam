import 'package:MayTeam/core/constant/color.dart';
import 'package:MayTeam/core/constant/text_style.dart';
import 'package:MayTeam/core/constant/ui_const.dart';
import 'package:MayTeam/core/model/login.dart';
import 'package:MayTeam/core/service/provider/auth.dart';
import 'package:MayTeam/core/util/extension.dart';
import 'package:MayTeam/core/util/validator.dart';
import 'package:MayTeam/widget/button/loading_button.dart';
import 'package:MayTeam/widget/form/app_form_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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

  Future<void> send() async {
    if(_formKey.currentState!.validate()) {
      context.read<AutherProvider>().login(LoginModel(email: emailController.text, password: passwordController.text))
          .then((value) {
            if(value == null) {
              context.go('/');
            }
            else {
              print('HATALI giriş');
              //context.showAppDialog();
            }
      });
    }
  }

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
                  onTap: send,
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