import 'package:MayTeam/core/constant/color.dart';
import 'package:MayTeam/core/constant/ui_const.dart';
import 'package:MayTeam/widget/base/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/service/firebase.dart';
import '../../core/service/provider/auth.dart';
import '../../widget/base/drawer.dart';
import '../../widget/base/scaffold.dart';
import '../../widget/tile/group_tile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin{
  Stream<DocumentSnapshot>? _groups;
  ScrollController? _controller;
  late AnimationController animationController;
  late Animation<Offset> offset;

  @override
  void initState() {
    super.initState();
    _getUserAuthAndJoinedGroups();
    _controller = ScrollController();
    animationController = AnimationController(
      vsync: this,
      duration: UIConst.animationDuration,
      reverseDuration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> openDrawer() async {
    await animationController.forward();
  }

  Future<void> closeDrawer() async {
    await animationController.reverse();
  }

  Future<void> changeDrawer() async {
    if (animationController.isCompleted) {
      await closeDrawer();
    } else {
      await openDrawer();
    }
  }

  Widget noGroupWidget() {
    return Container(
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
    double width = MediaQuery.of(context).size.width;
    return AppScaffold(
      appBar: AppAppBar(
        isDrawer: true,
        progress: animationController,
        onTap: changeDrawer,
      ),
      backgroundImage: false,
      backgroundColor: AppColor.primaryBackgroundColor,
      child: Stack(
        children: [
          Positioned.fill(child: groupsList()),
          Positioned.fill(
              child: AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  var offsetValue = Tween<double>(begin: -width, end: 0).animate(CurvedAnimation(parent: animationController, curve: Curves.ease));
                  return Transform.translate(
                    offset: Offset(offsetValue.value, 0),
                    child: PopScope(
                      onPopInvoked: (canPop) async {
                        if(animationController.isCompleted) {
                          await closeDrawer();
                        }
                        else {
                          context.pop();
                        }
                      },
                      child: AppDrawer(
                        onWillCloseDrawer: () async {
                          closeDrawer();
                        },
                      ),
                    ),
                  );
                },
              )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 2.0,
        backgroundColor: AppColor.secondaryBackgroundColor,
        onPressed: () {
          context.push('/search');
        },
        child: Icon(Icons.search, color: AppColor.iconColor),
      ),
    );
  }
}