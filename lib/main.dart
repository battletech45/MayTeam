import 'package:MayTeam/core/constant/color.dart';
import 'package:MayTeam/core/constant/router_config.dart';
import 'package:MayTeam/core/service/provider/auth.dart';
import 'package:MayTeam/screen/auth_screen/reset_password_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
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

Future <void> providerInit() async {
  authProvider = AutherProvider();
  await authProvider.init();
}



