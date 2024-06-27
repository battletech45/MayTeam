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
import '../../widget/button/scale_button.dart';
import '../../widget/tile/group_tile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin{
  Stream<DocumentSnapshot>? _groups;

  static final _drawerWidth = UIConst.screenSize.width * 0.8;
  static double get drawerWidth => _drawerWidth;
  ScrollController scrollController = ScrollController(initialScrollOffset: drawerWidth);
  late AnimationController animationController;
  late Animation<double> animation;
  ScrollPhysics physics = const NeverScrollableScrollPhysics();
  bool isDragging = false;
  bool get isDrawerClosed => scrollController.offset == drawerWidth;

  bool get canpop {
    try {
      return isDrawerClosed;
    } catch (e) {
      return true;
    }
  }

  void scrollAnimationListener() {
    if (scrollController.offset >= 0 && scrollController.offset <= drawerWidth) {
      final d = scrollController.offset / drawerWidth;
      animationController.animateTo(d, duration: Duration.zero);
    }
  }

  void scrollPhysicsListener() {
    if (scrollController.offset >= drawerWidth) {
      if (physics is! NeverScrollableScrollPhysics) {
        physics = const NeverScrollableScrollPhysics();
        setState(() {});
      }
    } else {
      if (physics is! ClampingScrollPhysics) {
        physics = const ClampingScrollPhysics();
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserAuthAndJoinedGroups();
    animationController = AnimationController(vsync: this, duration: UIConst.animationDuration, value: 1);
    animation = Tween<double>(begin: 0.5, end: 0).animate(animationController);
    scrollController.addListener(scrollAnimationListener);
    scrollController.addListener(scrollPhysicsListener);
  }

  @override
  void dispose() {
    scrollController.dispose();
    animationController.dispose();
    super.dispose();
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
    return Material(
      child: PopScope(
        canPop: canpop,
        onPopInvoked: (didPop) {
          if(canpop) {
            return;
          }
          scrollController.animateTo(drawerWidth, duration: UIConst.animationDuration, curve: Curves.ease);
        },
        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerMove: (event) {
            if (isDrawerClosed) return;
            if (event.delta.dx.abs() != 0) {
              isDragging = true;
            }
          },
          onPointerUp: (event) {
            if (isDrawerClosed) return;
            if (isDragging == true) {
              isDragging = false;
              if (scrollController.offset >= drawerWidth * 0.5) {
                scrollController.animateTo(drawerWidth, duration: UIConst.animationDuration, curve: Curves.ease);
                return;
              }
              scrollController.animateTo(0, duration: UIConst.animationDuration, curve: Curves.ease);
              return;
            }
          },
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            physics: physics,
            child: Row(
              children: [
                AppDrawer(
                    width: drawerWidth,
                    onWillCloseDrawer: () async {
                      await scrollController.animateTo(drawerWidth, duration: UIConst.animationDuration, curve: Curves.ease);
                    }
                ),
                GestureDetector(
                  onTap: () async {
                    if (scrollController.offset != drawerWidth) {
                      await scrollController.animateTo(drawerWidth, duration: UIConst.animationDuration, curve: Curves.ease);
                    }
                  },
                  child: SizedBox(
                    width: UIConst.screenSize.width,
                    height: UIConst.screenSize.height,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        AppScaffold(
                          appBar: AppAppBar(
                            isDrawer: true,
                            progress: animationController,
                            leading: ScaleButton(
                              waitAnimation: true,
                                bordered: false,
                                onTap: () async {
                                  if (scrollController.offset == drawerWidth) {
                                    await scrollController.animateTo(0, duration: UIConst.animationDuration, curve: Curves.ease);
                                    return;
                                  }
                                  await scrollController.animateTo(drawerWidth, duration: UIConst.animationDuration, curve: Curves.ease);
                                },
                                child: const Icon(Icons.menu)
                            ),
                          ),
                          backgroundImage: false,
                          backgroundColor: AppColor.primaryBackgroundColor,
                          child: groupsList(),
                          floatingActionButton: FloatingActionButton(
                            elevation: 2.0,
                            backgroundColor: AppColor.secondaryBackgroundColor,
                            onPressed: () {
                              context.push('/search');
                            },
                            child: Icon(Icons.search, color: AppColor.iconColor),
                          ),
                        ),
                        AnimatedBuilder(
                          animation: animation,
                          builder: (context, _) {
                            return Opacity(
                              opacity: animation.value,
                              child: Material(
                                color: Colors.black,
                                //? [MaterialType.transparency] tıklama geçirgenliği için kullanıldı
                                type: animation.value == 0 ? MaterialType.transparency : MaterialType.button,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}