import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'MAYteam/GameGroupPage.dart';
import 'MAYteam/SideFunctions.dart';
import 'MAYteam/AdminPage.dart';
import 'MAYteam/LoginPage.dart';
import 'MAYteam/SignUpPage.dart';
import 'firebase_options.dart';

final loginProvider = Provider((_) => 'LOGIN');
final signUpProvider = Provider((_) => 'SIGN UP');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      ProviderScope(child: MyApp())
  );
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
    print(isLoggedIn);
    if(savedLoggedIn != null){
      setState(() {
        isLoggedIn = savedLoggedIn;
      });
    }
    print(isLoggedIn);
    var savedEmail = await SideFunctions.getUserEmailSharedPreference();
    if(savedEmail == "taneri862@gmail.com") {
      setState(() {
        isAdmin = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  @override
  Widget build(BuildContext context) {
       return !isLoggedIn ? MaterialApp(
         debugShowCheckedModeBanner: false,
        title: 'M.A.Y. TEAM',
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: Scaffold(
          body: new Container(
            alignment: Alignment.center,
            color: Colors.brown[900],
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/logo.png', width: 200, height: 200),
                  SizedBox(height: 20.0),
                  loginButton(),
                  signUpButton()
                ]
            ),
          ),
        ),
      ) : MaterialApp(
         debugShowCheckedModeBanner: false,
           theme: ThemeData(brightness: Brightness.dark),
           home: isAdmin ? AdminPage() : HomePage()
       );
  }
}


class loginButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String text = ref.watch(loginProvider);
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
class signUpButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String text = ref.watch(signUpProvider);
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



