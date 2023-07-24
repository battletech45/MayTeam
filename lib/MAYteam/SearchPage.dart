import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'SideFunctions.dart';
import 'ChatPage.dart';
import 'Firebase_functions.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot? searchResultSnapshot;
  Stream<QuerySnapshot>? allGroupsSnapshot;
  ScrollController? _controller;
  bool isLoading = false;
  bool hasUserJoined = false;
  String _userName = '';
  User? _user;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _getCurrentUserNameAndUserID();
    _getAllGroups();
    _controller = ScrollController();
  }

  _getCurrentUserNameAndUserID() async {
    await SideFunctions.getUserNameSharedPreference().then((value) {
      _userName = value!;
    });
    _user = FirebaseAuth.instance.currentUser!;
  }

  _initiateSearch() async {
    if(searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await FirebaseFunctions().searchByName(searchEditingController.text).then((snapshot) {
        searchResultSnapshot = snapshot;
        setState(() {
          isLoading = false;
          hasUserJoined = true;
        });
      });
    }
  }

  _getAllGroups () async {
    var val = await FirebaseFunctions().getAllGroups();
    setState(() {
      allGroupsSnapshot = val;
    });
  }

  void _showPopupDialog(BuildContext context, String groupName, String groupID, String userName) {
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
    AlertDialog userAlert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text("Already Joined !"),
      content: Text('You already joined to group $groupName.'),
      actions: [
        cancelButton
      ],
    );
    Widget joinButton = MaterialButton(
      child: Text("Join"),
      elevation: 5.0,
      color: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      splashColor: Colors.red[900],
      onPressed: () async {
        bool val = await FirebaseFunctions(userID: _user!.uid).isUserJoined(groupID, groupName, userName);
        if(!val) {
          await FirebaseFunctions(userID: _user!.uid).togglingGroupJoin(groupID, groupName, userName);
          Future.delayed(Duration(milliseconds: 1000), () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(groupID: groupID, userName: userName, groupName: groupName)));
          });
        }
        else {
          Navigator.of(context).pop();
          showDialog(context: context, builder: (BuildContext context) {
            return userAlert;
          });
        }
      },
    );

    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text("You will join: $groupName"),
      content: Text('Are you sure to join group $groupName ?'),
      actions: [
        cancelButton,
        joinButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget groupList() {
    return hasUserJoined ? ListView.builder(
        physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: searchResultSnapshot!.docs.length,
      itemBuilder: (context, index) {
        return groupTile(
          _userName,
          searchResultSnapshot!.docs[index].get("groupID"),
          searchResultSnapshot!.docs[index].get("groupName"),
          searchResultSnapshot!.docs[index].get("admin"),
        );
      }
    ) : StreamBuilder <QuerySnapshot>(
      stream: allGroupsSnapshot,
        builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return groupTile(
                  _userName,
                  snapshot.data!.docs[index].get("groupID"),
                  snapshot.data!.docs[index].get("groupName"),
                  snapshot.data!.docs[index].get("admin"),
                );
              }
          ) :
            CircularProgressIndicator();
        }
    );
  }

  Widget groupTile(String userName, String groupID, String groupName, String admin){
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      leading: CircleAvatar(
        radius: 30.0,
        backgroundColor: Colors.brown[900],
        child: Text(groupName.substring(0, 1).toUpperCase(), style: TextStyle(color: Colors.white))
      ),
      title: Text(groupName, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("Admin: $admin"),
      onTap: () => _showPopupDialog(context, groupName, groupID, userName),
      trailing: Icon(Icons.add_circle, size: 30.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.brown[900],
        title: Text('Search', style: TextStyle(fontSize: 27.0, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: Container(
        child: Scrollbar(
          interactive: true,
          thickness: 7.5,
          trackVisibility: true,
          controller: _controller,
          child: SingleChildScrollView(
            controller: _controller,
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(80)),
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onSubmitted: (val) => {
                            _initiateSearch()
                            },
                          controller: searchEditingController,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              hintText: "Search groups...",
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              border: InputBorder.none
                          ),
                        ),
                      ),
                      GestureDetector(
                          onTap: (){
                            _initiateSearch();
                          },
                          child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(40)
                              ),
                              child: Icon(Icons.search, color: Colors.white)
                          )
                      )
                    ],
                  ),
                ),
                isLoading ? Container(child: Center(child: CircularProgressIndicator())) : groupList()
              ],
            ),
          ),
        ),
      ),
    );
  }
}