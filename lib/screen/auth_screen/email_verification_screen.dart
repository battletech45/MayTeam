import 'package:MayTeam/core/service/provider/auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/service/firebase.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});
  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isVerified = false;
  bool _isLoading = false;

  _getVerificationValue() async {
    setState(() {
      _isLoading = true;
    });
    await context.read<AutherProvider>().user?.reload();
    setState(() {
      _isVerified = context.read<AutherProvider>().user?.emailVerified ?? false;
    });
    if(_isVerified) {
      setState(() {
        _isLoading = false;
      });
      context.go('/');
    }
    else {
      setState(() {
        _isLoading = false;
      });
      _showPopupDialog();
    }
  }

  void _showPopupDialog() {
    Widget okButton = MaterialButton(
      child: Text("OK"),
      color: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      splashColor: Colors.red[900],
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      icon: Icon(Icons.mark_email_unread),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text("Please check your mailbox for verification !"),
      actions: <Widget>[okButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
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
                child: _isLoading ? CircularProgressIndicator(color: Colors.black, strokeWidth: 3.5) : Text('Check Verification'),
                onPressed: _getVerificationValue
            ),
            MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                color: Colors.black,
                child: Text('Back'),
                onPressed: () => context.go('/')
            ),
          ],
        ),
      ),
    );
  }
}
