import 'package:MayTeam/MAYteam/Firebase_functions.dart';
import 'package:MayTeam/MAYteam/SideFunctions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:MayTeam/MAYteam/GameGroupPage.dart';
import 'package:MayTeam/main.dart';

class VerificationPage extends StatefulWidget {
  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _user = FirebaseAuth.instance;
  bool _isVerified = false;
  String _userName = '';


  _getUserName() async {
    var snapshot = await FirebaseFunctions().getUserData(_user.currentUser.email);
    for(int i = 0; i < snapshot.docs.length; i++) {
      if(snapshot.docs[i].get("email") == _user.currentUser.email) {
        setState(() {
          _userName = snapshot.docs[i].get("fullName");
        });
      }
    }
  }

  _getVerificationValue() async {
    await _user.currentUser.reload();
    setState(() {
      _isVerified = _user.currentUser.emailVerified;
    });
    print(_isVerified);
    print(_user.currentUser.email);
    print(_user.currentUser.uid);
    if(_isVerified) {
      await SideFunctions.saveUserLoggedInSharedPreference(true);
      await SideFunctions.saverUserEmailSharedPreference(_user.currentUser.email);
      await SideFunctions.saveUserNameSharedPreference(_userName);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color:Colors.brown [900],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.email_outlined, size: 100.0),
            SizedBox(height: 20.0),
            Text('Please Verify Your E-Mail !', style: TextStyle(fontSize: 30.0)),
            SizedBox(height: 30.0),
            MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                color: Colors.red,
                child: Text('Check Verification'),
                  onPressed: _getVerificationValue
            ),MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                color: Colors.black,
                child: Text('Back'),
                onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MyApp()))
            ),
          ],
        ),
      ),
    );
  }
}
