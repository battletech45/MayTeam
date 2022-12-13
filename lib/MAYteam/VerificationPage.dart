import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/MAYteam/GameGroupPage.dart';
import 'package:flutter_app/main.dart';

class VerificationPage extends StatefulWidget {
  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _user = FirebaseAuth.instance;
  bool _isVerified = false;

  _getVerificationValue() async {
    await _user.currentUser.reload();
    setState(() {
      _isVerified = _user.currentUser.emailVerified;
    });
    print(_isVerified);
    print(_user.currentUser.email);
    print(_user.currentUser.uid);
    if(_isVerified) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor:Colors.brown[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white),
          onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MyApp()))
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        color:Colors.brown [900],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Please Verify Your E-Mail !', style: TextStyle(fontSize: 30.0)),
            MaterialButton(
              color: Colors.red,
              child: Text('Check Verification'),
                onPressed: _getVerificationValue
            ),
          ],
        ),
      ),
    );
  }
}
