import 'package:MayTeam/MAYteam/SideFunctions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'GameGroupPage.dart';


class ProfilePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ProfilePageState();
}
class ProfilePageState extends State<ProfilePage> {
  String userName = '';
  String userEmail = '';

  _getUserName() async {
    print(userName);
    print(userEmail);
    var name = await SideFunctions.getUserNameSharedPreference();
    setState(() {
      userName = name;
    });
    var email = await SideFunctions.getUserEmailSharedPreference();
    setState(() {
      userEmail = email;
    });
    print(userName);
    print(userEmail);
  }

  @override
  void initState() {
    super.initState();
    _getUserName();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        backgroundColor: Colors.brown[900],
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
          ),
        ],
        title: Text("Profile"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white),
          onPressed: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
      ),
      body: Container(
          child: ListView(
            children: <Widget>[
              Container(
                width:200,
                height: 200,
                margin: EdgeInsets.all(15),
                child: Center(
                  child: CircleAvatar(
                    radius: 78,
                    child: Icon(Icons.person,size: 80.0,),
                  ),
                ),
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(color: Colors.deepOrange[900], borderRadius: BorderRadius.circular(50)),
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                child: Center(
                 child: Text("$userName"),
                ),
              ),
              SizedBox(height: 25.0),
              Container(
                height: 40,
                decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(50)),
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                child: Center(
                  child: Text("$userEmail"),
                ),
              ),
              SizedBox(height: 25.0),
              Container(
                height: 40,
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50)),
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                child: Center(
                  child: Text("NBA 2K23"),
                ),
              ),
            ],
     ),
    ),
    );
  }

}
