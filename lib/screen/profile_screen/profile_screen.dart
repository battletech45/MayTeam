import 'package:MayTeam/core/service/firebase.dart';
import 'package:MayTeam/core/service/provider/auth.dart';
import 'package:MayTeam/widget/base/appbar.dart';
import 'package:MayTeam/widget/base/scaffold.dart';
import 'package:MayTeam/widget/tile/profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../../core/constant/color.dart';


class ProfileScreen extends StatefulWidget{
  const ProfileScreen({super.key});
  @override
  State<StatefulWidget> createState() => ProfileScreenState();
}
class ProfileScreenState extends State<ProfileScreen> {
  String? link;
  bool _isPhotoExist = false;
  String? _activeGroup;

  _getActiveGroup() async {
    var userData = await FirebaseService.getUserData(context.read<AutherProvider>().user!.uid);
    setState(() {
      _activeGroup = userData.get('activeGroup');
    });
  }

  @override
  void initState() {
    super.initState();
    _getActiveGroup();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundImage: false,
      backgroundColor: AppColor.primaryBackgroundColor,
      appBar: AppAppBar(
        isDrawer: false,
        title: 'Profil',
      ),
      child: Container(
          child: Column(
            children: <Widget>[
              50.verticalSpace,
              GestureDetector(
                onTap: () async {},
                child: Container(
                  margin: EdgeInsets.all(15),
                  child: Center(
                    child: CircleAvatar(
                      radius: 95,
                      child: _isPhotoExist ? CircleAvatar(radius: 90, backgroundImage: CachedNetworkImageProvider(link!)) : Icon(Icons.person,size: 80.0),
                    ),
                  ),
                ),
              ),
              50.verticalSpace,
              ProfileTile(icon: Icons.person_outline_rounded, data: "${context.read<AutherProvider>().user?.displayName ?? ''}"),
              10.verticalSpace,
              ProfileTile(icon: Icons.alternate_email_rounded, data: "${context.read<AutherProvider>().user?.email ?? ''}"),
              10.verticalSpace,
              ProfileTile(icon: Icons.games, data: "$_activeGroup")
            ],
     ),
    ),
    );
  }

}
