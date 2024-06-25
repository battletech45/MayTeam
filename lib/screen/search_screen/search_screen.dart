import 'package:MayTeam/core/constant/color.dart';
import 'package:MayTeam/core/constant/ui_const.dart';
import 'package:MayTeam/widget/base/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../core/constant/text_style.dart';
import '../../core/service/firebase.dart';
import '../../core/service/provider/auth.dart';
import '../../widget/base/scaffold.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot? searchResultSnapshot;
  Stream<QuerySnapshot>? allGroupsSnapshot;
  ScrollController? _controller;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _getCurrentUserNameAndUserID();
    _getAllGroups();
    _controller = ScrollController();
  }

  _getCurrentUserNameAndUserID() async {
    var data = await FirebaseService.getUserData(context.read<AutherProvider>().user!.email ?? '');
  }

  _initiateSearch() async {
    if(searchEditingController.text.isNotEmpty) {
      await FirebaseService.searchByName(searchEditingController.text).then((snapshot) {
        searchResultSnapshot = snapshot;
      });
    }
  }

  _getAllGroups () async {
    var val = await FirebaseService.getAllGroups();
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
        bool val = await FirebaseService.isUserJoined(context.read<AutherProvider>().user!.uid, groupID, groupName, userName);
        if(!val) {
          await FirebaseService.togglingGroupJoin(context.read<AutherProvider>().user!.uid, groupID, groupName, userName, '');
          Future.delayed(Duration(milliseconds: 1000), () {
            Navigator.of(context).pop();
            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(groupID: groupID, userName: userName, groupName: groupName, userToken: token!)));
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
    return StreamBuilder <QuerySnapshot>(
        stream: allGroupsSnapshot,
        builder: (context, snapshot) {
          return snapshot.hasData ? ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return groupTile(
                  context.read<AutherProvider>().user?.displayName ?? '',
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

  Widget groupTile(String userName, String groupID, String groupName, String admin) {
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
    return AppScaffold(
      backgroundColor: AppColor.primaryBackgroundColor,
      backgroundImage: false,
      appBar: AppAppBar(
        isDrawer: false,
      ),
      child: SingleChildScrollView(
        controller: _controller,
        physics: BouncingScrollPhysics(),
        padding: UIConst.pagePadding,
        child: Column(
          children: [
            UIConst.verticalBlankSpace,
            Container(
              decoration: BoxDecoration(color: AppColor.secondaryBackgroundColor, borderRadius: BorderRadius.circular(80.r)),
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onSubmitted: (val) => {
                        _initiateSearch()
                      },
                      controller: searchEditingController,
                      style: AppTextStyle.bigButtonText.copyWith(color: AppColor.primaryTextColor),
                      decoration: InputDecoration(
                          hintText: "Search groups...",
                          hintStyle: AppTextStyle.bigButtonText.copyWith(color: AppColor.primaryTextColor),
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
          ],
        ),
      ),
    );
  }
}