import 'package:MayTeam/core/constant/color.dart';
import 'package:MayTeam/core/constant/ui_const.dart';
import 'package:MayTeam/core/util/extension.dart';
import 'package:MayTeam/widget/base/appbar.dart';
import 'package:MayTeam/widget/dialog/alert_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constant/text_style.dart';
import '../../core/service/firebase.dart';
import '../../core/service/provider/auth.dart';
import '../../widget/base/scaffold.dart';
import '../../widget/tile/search_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchEditingController = new TextEditingController();
  List searchResult = [];
  QuerySnapshot? allGroupsSnapshot;
  ScrollController? _controller;


  @override
  void initState() {
    super.initState();
    _getAllGroups();
    _controller = ScrollController();
  }

  Future<void> _initiateSearch() async {
      if(allGroupsSnapshot != null && allGroupsSnapshot!.docs.isNotEmpty) {
        searchResult.clear();
        setState(() {});
        allGroupsSnapshot!.docs.forEach((element) {
          String name = element.get('groupName').toLowerCase();
          if(name.contains(searchEditingController.text.toLowerCase())) {
            setState(() {
              searchResult.add(element);
            });
          }
        });
      }
  }

  Future<void> _getAllGroups () async {
    var val = await FirebaseService.getAllGroups();
    if(val.docs.isNotEmpty) {
      setState(() {
        allGroupsSnapshot = val;
      });
    }
  }

  Future<void> _onTileClick(QueryDocumentSnapshot doc) async {
    bool val = await FirebaseService.isUserJoined(context.read<AutherProvider>().user!.uid, doc.get("groupID"), doc.get("groupName"), context.read<AutherProvider>().user!.displayName ?? '');
    if(!val) {
      await FirebaseService.togglingGroupJoin(context.read<AutherProvider>().user!.uid, doc.get("groupID"), doc.get("groupName"), context.read<AutherProvider>().user!.displayName ?? '');
      context.push('/chat/${doc.get("groupID")}', extra: doc.get("groupName"));
    }
    else {
      context.showAppDialog(
          AppAlertDialog(
            type: AlertType.warn,
            isSingleButton: true,
            text: 'Bu gruba zaten üyesiniz !',
            title: 'Hata',
          )
      );
    }
  }

  Widget groupList() {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: searchResult.isEmpty ? (allGroupsSnapshot?.docs.length ?? 0) : (searchResult.length),
        itemBuilder: (context, index) {
          if(allGroupsSnapshot != null && searchResult.isEmpty) {
            return SearchTile(
              groupName: allGroupsSnapshot!.docs[index].get("groupName"),
              admin: allGroupsSnapshot!.docs[index].get("admin"),
              onTap: () => context.showAppDialog(
                  AppAlertDialog(
                    type: AlertType.joining,
                    isSingleButton: false,
                    repeat: true,
                    text: '${allGroupsSnapshot!.docs[index].get("groupName")} odasına giriş yapmak istiyor musunuz ?',
                    title: 'Giriş Yap',
                    leftFunction: () async {
                      _onTileClick(allGroupsSnapshot!.docs[index]);
                    },
                  )
              ),
            );
          }
          else if(searchResult.isNotEmpty) {
            return SearchTile(
                groupName: searchResult[index].get("groupName"),
                admin: searchResult[index].get("admin"),
                onTap: () => context.showAppDialog(
                    AppAlertDialog(
                      type: AlertType.joining,
                      isSingleButton: false,
                      repeat: true,
                      text: '${searchResult[index].get("groupName")} odasına giriş yapmak istiyor musunuz ?',
                      title: 'Giriş Yap',
                      leftFunction: () async {
                        _onTileClick(searchResult[index]);
                      },
                    )
                )
            );
          }
          else {
            return const SizedBox.shrink();
          }
        }
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
                      onChanged: (val) => {_initiateSearch()},
                      controller: searchEditingController,
                      style: AppTextStyle.bigButtonText.copyWith(color: AppColor.primaryTextColor),
                      decoration: InputDecoration(
                          hintText: "Search groups...",
                          hintStyle: AppTextStyle.bigButtonText.copyWith(color: AppColor.primaryTextColor),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  Icon(Icons.search, color: AppColor.primaryTextColor)
                ],
              ),
            ),
            groupList()
          ],
        ),
      ),
    );
  }
}