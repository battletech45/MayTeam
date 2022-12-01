import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'LoginPage.dart';
import 'SignUpPage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                loginButton(),
                signUpButton()
            ]
          ),
          ),
    ),
    );
  }
}


class loginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
       child: const Text('LOGIN'),
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
    return MaterialButton(
      child: const Text('SIGN UP'),
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



