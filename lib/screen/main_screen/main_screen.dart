import 'dart:convert';

import 'package:MayTeam/core/constant/color.dart';
import 'package:MayTeam/core/constant/ui_const.dart';
import 'package:MayTeam/core/service/log.dart';
import 'package:MayTeam/core/util/extension.dart';
import 'package:MayTeam/widget/base/appbar.dart';
import 'package:MayTeam/widget/dialog/alert_dialog.dart';
import 'package:MayTeam/widget/form/app_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/service/firebase.dart';
import '../../core/service/notification.dart';
import '../../core/service/provider/auth.dart';
import '../../core/service/provider/theme.dart';
import '../../core/util/validator.dart';
import '../../widget/animation/animated_logo.dart';
import '../../widget/base/drawer.dart';
import '../../widget/base/scaffold.dart';
import '../../widget/button/scale_button.dart';
import '../../widget/tile/group_tile.dart';

late NotificationService notificationService;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  Stream<DocumentSnapshot>? _groups;
  final TextEditingController groupNameController = TextEditingController();

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

  Future<void> initNotification() async {
    notificationService = NotificationService(context);
    await notificationService.initNotification();
    //await FirebaseMessaging.instance.subscribeToTopic('group_notification');
    FirebaseMessaging.onMessage.listen(foregroundMessageListener);
    FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);
    await FirebaseMessaging.instance.getInitialMessage().then((initMessage) {
      LoggerService.logInfo('initMessage: $initMessage');
      if (initMessage != null) {
        LoggerService.logInfo('initMessage data: ${initMessage.data}');
        GoRouter.of(context).push(initMessage.data['page']);
      }
    });
  }

  Future<void> onNotificationClick() async {
    await notificationService.plugin.getNotificationAppLaunchDetails().then(
          (appLaunchDetail) {
        if (appLaunchDetail != null && appLaunchDetail.didNotificationLaunchApp) {
          if (appLaunchDetail.notificationResponse != null && appLaunchDetail.notificationResponse!.payload != null) {
            var json = jsonDecode(appLaunchDetail.notificationResponse!.payload!);
            if (json is Map) {
              var page = json['page'];
              if (page != null) {
                context.push(page);
              }
            }
          }
        }
      },
    );
  }

  Future<void> onMessageOpenedApp(RemoteMessage message) async {
    LoggerService.logInfo('onMessageOpenedApp: data: ${message.data}');
    if (message.data['page'] != null) {
      LoggerService.logInfo('message data is not null \nnavigating: ${message.data['page']}');
      GoRouter.of(context).push(message.data['page']);
    }
  }

  Future<void> foregroundMessageListener(RemoteMessage message) async {
    LoggerService.logInfo('\x1B[31mforgroundMessageListener: ${jsonEncode(message.toMap())}');
    if (message.data.isNotEmpty) {
      notificationService.showNotification(
        id: 0,
        body: message.notification?.body,
        title: message.notification?.title,
        payload: jsonEncode(message.data),
      );
    } else {
      notificationService.showNotification(
        id: 0,
        body: message.notification?.body,
        title: message.notification?.title,
      );
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
            Icon(Icons.search, color: AppColor.secondaryTextColor, size: 75.0),
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
          if(data!['chats'] != null) {
            if(data['chats'].length != 0) {
              return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: data['chats'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int reqIndex = data['chats'].length - index - 1;
                    return GroupTile(userName: data['displayName'], groupID: _destructureId(data['chats'][reqIndex]), groupName: _destructureName(data['chats'][reqIndex]));
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
          return AnimatedLogo();
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


  String _destructureName(String res) {
    return res.substring(res.indexOf('_') + 1);
  }

  String _destructureId(String res) {
    return res.substring(0, res.indexOf('_'));
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
                            actions: [
                              IconButton(
                                onPressed: () async {
                                  context.showAppDialog(
                                    AppAlertDialog(
                                      title: 'Yeni Oda Oluştur',
                                      leftButtonText: 'Oluştur',
                                      leftFunction: () async {
                                        await FirebaseService.createGroup(context.read<AutherProvider>().user!.uid, groupNameController.text);
                                      },
                                      height: 100.h,
                                      customIcon: Center(
                                        child: AppFormField(
                                          hintText: 'Grup Adı',
                                          controller: groupNameController,
                                          validator: AppValidator.passwordValidator,
                                          keyboardType: TextInputType.text,
                                          autofillHints: const [AutofillHints.name],
                                          textInputAction: TextInputAction.done,
                                        ),
                                      ),
                                    )
                                  );
                                },
                                icon: Icon(Icons.add),
                              )
                            ],
                            leading: ScaleButton(
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                              ),
                              waitAnimation: true,
                                bordered: false,
                                onTap: () async {
                                  if (scrollController.offset == drawerWidth) {
                                    await scrollController.animateTo(0, duration: UIConst.animationDuration, curve: Curves.ease);
                                    return;
                                  }
                                  await scrollController.animateTo(drawerWidth, duration: UIConst.animationDuration, curve: Curves.ease);
                                },
                                child: Center(child: const Icon(Icons.menu))
                            ),
                          ),
                          backgroundImage: false,
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