import 'package:MayTeam/core/constant/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/service/firebase.dart';
import '../../core/service/provider/auth.dart';
import '../../widget/base/scaffold.dart';
import '../../widget/tile/group_tile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
          if(data!['groups'] != null) {
            if(data['groups'].length != 0) {
              return ListView.builder(
                  controller: _controller,
                  physics: BouncingScrollPhysics(),
                  itemCount: data['groups'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int reqIndex = data['groups'].length - index - 1;
                    return GroupTile(userName: data['fullName'], groupID: _destructureId(data['groups'][reqIndex]), groupName: _destructureName(data['groups'][reqIndex]), userToken: data['token']);
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
    FirebaseService.getUserGroups(context.read<AutherProvider>().user!.uid).then((Stream<DocumentSnapshot> snapshots) {
      setState(() {
        _groups = snapshots;
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
    return AppScaffold(
      backgroundImage: false,
      backgroundColor: AppColor.primaryBackgroundColor,
      child: groupsList(),
    );
  }
}