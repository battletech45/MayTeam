import 'package:MayTeam/constants/routes.dart';
import 'package:MayTeam/screens/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'MAYteam/GameGroupPage.dart';
import 'MAYteam/Notification.dart';
import 'MAYteam/SideFunctions.dart';
import 'MAYteam/AdminPage.dart';
import 'screens/login/LoginPage.dart';
import 'MAYteam/SignUpPage.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: "lib/.env");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  bool isAdmin = false;

  _checkUserStatus() async {
    var savedLoggedIn = await SideFunctions.getUserLoggedInSharedPreference();
    if (savedLoggedIn != null) {
      setState(() {
        isLoggedIn = savedLoggedIn;
      });
    }
    var savedEmail = await SideFunctions.getUserEmailSharedPreference();
    //TODO FIX
    if (savedEmail == "taneri862@gmail.com") {
      setState(() {
        isAdmin = true;
      });
    }
  }

  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';

  _changeBody(String msg) => setState(() => notificationBody = msg);
  _changeTitle(String msg) => setState(() => notificationTitle = msg);

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
    final _firebaseMessaging = FCM();
    _firebaseMessaging.setNotifications();
    NotificationHelper.initialize();

    _firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
    _firebaseMessaging.titleCtlr.stream.listen(_changeTitle);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'M.A.Y. TEAM',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: LandingScreen(),
      getPages: [
        GetPage(
          name: Routes.landing,
          page: () => LandingScreen(),
        ),
        GetPage(name: Routes.register, page: () => RegisterPage()),
        GetPage(name: Routes.login, page: () => SignInPage()),
        GetPage(name: Routes.home, page: () => HomePage()),
        GetPage(name: Routes.admin, page: () => AdminPage()),
      ],
    );
  }
}
