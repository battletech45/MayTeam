import 'package:MayTeam/core/constant/color.dart';
import 'package:MayTeam/core/constant/router_config.dart';
import 'package:MayTeam/core/service/provider/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'MAYteam/LoginPage.dart';
import 'MAYteam/SignUpPage.dart';
import 'firebase_options.dart';

late AutherProvider authProvider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.top]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await providerInit();
  await Future.delayed(const Duration(seconds: 1));
  runApp(MayTeam());
}

class MayTeam extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
       return MultiProvider(
         providers: [
           ChangeNotifierProvider.value(value: authProvider)
         ],
         builder: (context, __) {
           return ScreenUtilInit(
             designSize: const Size(393, 808),
             builder: (context, __) {
               return MaterialApp.router(
                 color: AppColor.secondary,
                 routerConfig: AppRouterConfig.router,
                 debugShowCheckedModeBanner: false,
                 scrollBehavior: const CupertinoScrollBehavior(),
                 builder: (context, child) {
                   return MediaQuery(
                       data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
                       child: child!
                   );
                 },
               );
             },
           );
         },
       );
  }
}


class loginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String text = 'Login';
    return MaterialButton(
       child: Text(text),
      elevation: 5.0,
      color: Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      splashColor: Colors.black,
      onPressed: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignInPage()));
      },
    );
  }
}
class signUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String text = 'Sign Up';
    return MaterialButton(
      child: Text(text),
      color: Colors.black,
      elevation: 5.0,
      splashColor: Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      onPressed: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RegisterPage()));
      },
    );
  }
}

Future <void> providerInit() async {
  authProvider = AutherProvider();
  await authProvider.init();
}



