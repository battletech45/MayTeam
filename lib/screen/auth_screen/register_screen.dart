import 'package:MayTeam/core/constant/color.dart';
import 'package:MayTeam/core/constant/ui_const.dart';
import 'package:MayTeam/core/model/login.dart';
import 'package:MayTeam/core/service/provider/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:provider/provider.dart';
import '../../core/constant/text_style.dart';
import '../../core/util/validator.dart';
import '../../widget/base/scaffold.dart';
import '../../widget/button/loading_button.dart';
import '../../widget/form/app_form_field.dart';
import '../../widget/form/phone_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  PhoneNumber phoneNumber = PhoneNumber(countryISOCode: 'TR', countryCode: '90', number: '');

  Future<void> send() async {
    if(_formKey.currentState!.validate()) {
      context.read<AutherProvider>().register(nameController.text, LoginModel(email: emailController.text, password: passwordController.text), phoneNumber.number)
      .then((value) {
        if(value == null) {
          context.go('/');
        }
        else {
          print('Bir Hata oluştu');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
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
                Text("Sign In", style: AppTextStyle.dialogTitle),
                UIConst.verticalBlankSpace,
                AppFormField(
                  hintText: 'Name',
                  controller: nameController,
                  validator: AppValidator.emptyValidator,
                  keyboardType: TextInputType.name,
                  autofillHints: const [AutofillHints.name],
                  textInputAction: TextInputAction.next,
                ),
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
                PhoneField(
                  onChanged: (value) {
                    phoneNumber = value;
                  },
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
                  child: Text('Register'),
                ),
                UIConst.verticalBlankSpace,
                Text.rich(
                  TextSpan(
                    text: "Already have an account? ",
                    style: AppTextStyle.dialogText,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Sign In',
                        style: AppTextStyle.dialogText.copyWith(decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          context.go('/login');
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