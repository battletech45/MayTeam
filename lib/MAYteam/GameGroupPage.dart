import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:MayTeam/MAYteam/ProfilePage.dart';
import '../main.dart';
import 'SideFunctions.dart';
import 'Auth_functions.dart';
import 'SearchPage.dart';
import 'Firebase_functions.dart';
import 'Chat_Group_Settings.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  User _user;
  String _userName = '';
  String _email = '';
  Stream<DocumentSnapshot> _groups ;

  @override
  void initState() {
    super.initState();
    _getUserAuthAndJoinedGroups();
  }

  Widget noGroupWidget() {
    return Container(
        color: Colors.grey[850],
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.search, color: Colors.grey, size: 75.0),
            SizedBox(height: 20.0),
            Text("You've not joined any group, tap on the 'search' icon"),
          ],
        )
    );
  }

  Widget groupsList() {
    return StreamBuilder <DocumentSnapshot>(
      stream: _groups,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if(snapshot.hasData) {
          var data = snapshot.data;
          if(data['groups'] != null) {
            if(data['groups'].length != 0) {
              return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: data['groups'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int reqIndex = data['groups'].length - index - 1;
                    return GroupTile(userName: data['fullName'], groupID: _destructureId(data['groups'][reqIndex]), groupName: _destructureName(data['groups'][reqIndex]));
                  }
              );
            }
            else {
              return noGroupWidget();
            }
          }
          else {
            return noGroupWidget();
          }
        }
        else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  _getUserAuthAndJoinedGroups() async {
    _user = await FirebaseAuth.instance.currentUser;
    await SideFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        _userName = value;
      });
    });
    FirebaseFunctions(userID: _user.uid).getUserGroups().then((Stream<DocumentSnapshot> snapshots) {
      setState(() {
        _groups = snapshots;
      });
    });
    await SideFunctions.getUserEmailSharedPreference().then((value) {
      setState(() {
        _email = value;
      });
    });
  }
  String _destructureId(String res) {
    return res.substring(0, res.indexOf('_'));
  }

  String _destructureName(String res) {
    return res.substring(res.indexOf('_') + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Groups', style: TextStyle(color: Colors.white, fontSize: 27.0, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.brown[900],
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              icon: Icon(Icons.search, color: Colors.white, size: 25.0),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchPage()));
              }
          )
        ],
      ),
      body: groupsList(),
      drawer: Drawer(
        elevation: 0.0,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage("images/logo.png"), fit: BoxFit.fitHeight)),
            ),
            ListTile(
              title: Text("Profile"),
              onTap: (){
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> ProfilePage()));
              }
            ),ListTile(
              title: Text("Sign Out"),
              onTap: (){
                AuthService().signOut().then((value) => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyApp())));
              }
            ),
          ],
        ),
      ),
    );
  }
}