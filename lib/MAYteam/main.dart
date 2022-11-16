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
          appBar: AppBar(
            title: Text('M.A.Y. TEAM'),
            backgroundColor: Colors.red,
          ),
          body: new Container(
            margin: const EdgeInsets.only(top: 210.0),
            child: new Column(
              children: [
                Container(
                  width: 577,
                  height: 121,
                  child: Image.asset('images/logo.png')),
            new Column(
              children: [loginButton(),signUpButton()],
            ),]
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
      color: Colors.red,
      elevation: 5.0,
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
      onPressed: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RegisterPage()));
      },
    );
  }
}



