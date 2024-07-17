import 'package:MayTeam/core/constant/router_config.dart';
import 'package:MayTeam/core/constant/ui_const.dart';
import 'package:MayTeam/core/service/provider/auth.dart';
import 'package:MayTeam/core/service/provider/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

late AutherProvider authProvider;
late String themeStr;

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
    UIConst.init(context);
       return MultiProvider(
         providers: [
           ChangeNotifierProvider.value(value: authProvider),
           ChangeNotifierProvider(create: (context) => ThemeProvider(themeString: themeStr))
         ],
         builder: (context, __) {
           return ScreenUtilInit(
             designSize: const Size(393, 808),
             builder: (context, __) {
               context.read<ThemeProvider>().init(context);
               return MaterialApp.router(
                 routerConfig: AppRouterConfig.router,
                 debugShowCheckedModeBanner: false,
                 scrollBehavior: const CupertinoScrollBehavior(),
                 theme: context.watch<ThemeProvider>().selected,
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
  themeStr = await checkSharedForTheme();
}

Future<String> checkSharedForTheme() async {
  final shared = await SharedPreferences.getInstance();

  if (shared.containsKey('theme')) {
    return shared.getString('theme')!;
  } else {
    return 'platform';
  }
}




