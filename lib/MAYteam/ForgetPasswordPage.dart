import 'package:flutter/material.dart';
import '../main.dart';

class ForgetPasswordPage extends StatefulWidget {

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.brown[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyApp()),
        ),
      ),
    ),
    body: Form(
      key: _formKey,
      child: Container(
        alignment: Alignment.center,
        color: Colors.brown[900],
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30.0),
                Text('Forget Password', style: TextStyle(color: Colors.white, fontSize: 25.0)),
                SizedBox(height: 30.0),
                Icon(Icons.email_outlined, size: 100.0),
                SizedBox(height: 30.0),
                Text('Please enter your e-mail here.', style: TextStyle(color: Colors.white, fontSize: 15.0)),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'EMAIL'
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (val) {
                    return RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val)
                        ? null
                        : "Please enter a valid email";
                  },
                  onChanged: (val) {
                    setState(() {
                      _email = val;
                    });
                  },
                ),
                SizedBox(height: 30.0),
                MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                    color: Colors.red,
                    child: _isLoading ? CircularProgressIndicator(color: Colors.black, strokeWidth: 3.5) : Text('Reset Password'),
                    onPressed: () {}
                )
              ],
            )
          ],
        ),
      ),
    ),
    );
  }
}