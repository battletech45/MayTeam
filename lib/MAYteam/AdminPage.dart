import 'package:MayTeam/core/service/firebase.dart';
import 'package:MayTeam/core/service/provider/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../widget/tile/group_tile.dart';
import 'Auth_functions.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  User? _user;
  String _groupName = '';
  String _userName = '';
  String _email = '';
  String userToken = '';
  Stream<DocumentSnapshot>? _groups;
  ScrollController? _controller;

  @override
  void initState() {
    super.initState();
    _getUserAuthAndJoinedGroups();
    _controller = ScrollController();
  }


  Widget noGroupWidget() {
    return Container(
      color: Colors.grey[850],
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.add_circle, color: Colors.white, size: 80.0),
            SizedBox(height: 20.0),
            Text("You've not joined any group, tap on the 'add' icon"),
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
          if(data?['groups'] != null) {
            if(data?['groups'].length != 0) {
              return Scrollbar(
                interactive: true,
                trackVisibility: true,
                thickness: 7.5,
                controller: _controller,
                child: ListView.builder(
                    controller: _controller,
                    physics: BouncingScrollPhysics(),
                    itemCount: data?['groups'].length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      int reqIndex = data?['groups'].length - index - 1;
                      return GroupTile(userName: data?['fullName'], groupID: _destructureId(data?['groups'][reqIndex]), groupName: _destructureName(data?['groups'][reqIndex]), userToken: data?['token']);
                    }
                ),
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
          return Center(
              child: CircularProgressIndicator()
          );
        }
      },
    );
  }

  _getUserAuthAndJoinedGroups() async {
    _user = FirebaseAuth.instance.currentUser;
    FirebaseService.getUserGroups(context.read<AutherProvider>().user!.uid).then((Stream<DocumentSnapshot> snapshots) {
      setState(() {
        _groups = snapshots;
      });
    });
    var data = await FirebaseService.getUserData(_email);
    setState(() {
      userToken = data.docs[0].get('token');
    });
  }

  String _destructureId(String res) {
    return res.substring(0, res.indexOf('_'));
  }

  String _destructureName(String res) {
    return res.substring(res.indexOf('_') + 1);
  }

  void _popupDialog(BuildContext context) {
    Widget cancelButton = MaterialButton(
      child: Text("Cancel"),
      elevation: 5.0,
      color: Colors.red[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      splashColor: Colors.black,
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget createButton = MaterialButton(
      child: Text("Create"),
      elevation: 5.0,
      color: Colors.red[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      splashColor: Colors.black,
      onPressed: () async {
        FirebaseService.createGroup(context.read<AutherProvider>().user!.uid, context.read<AutherProvider>().user!.displayName ?? '', _groupName, userToken);
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text("Create a group"),
      content: TextField(
          onChanged: (val) {
            _groupName = val;
          },
          style: TextStyle(
              fontSize: 15.0,
              height: 2.0,
              color: Colors.black
          )
      ),
      actions: [
        cancelButton,
        createButton,
      ],
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
      appBar: AppBar(
        title: Text('Admin Page', style: TextStyle(color: Colors.white, fontSize: 27.0, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.brown[900],
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              icon: Icon(Icons.search, color: Colors.white, size: 25.0),
              onPressed: () {
                context.go('/search');
              }
          )
        ],
      ),
      body: groupsList(),
      floatingActionButton: Transform.scale(
        scale: 1.2,
        child: FloatingActionButton(
          onPressed: () {
            _popupDialog(context);
          },
          child: Icon(Icons.add, color: Colors.white, size: 35.0),
          backgroundColor: Colors.brown[700],
          elevation: 0.0,
        ),
      ),
      drawer: Drawer(
        elevation: 0.0,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Image(image: AssetImage("images/logo.png"), fit: BoxFit.fitHeight)
            ),
            ListTile(
                title: Text("Profile"),
                onTap: (){
                  context.go('/profile');
                }
            ),
            ListTile(
                title: Text("Reset Password"),
                onTap: (){
                  context.go('/forgotPassword');
                }
            ),
            ListTile(
                title: Text("Sign Out"),
                onTap: (){
                  AuthService.signOut().then((value) => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MayTeam())));
                }
            ),
          ],
        ),
      ),
    );
  }
}