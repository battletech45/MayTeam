import 'package:MayTeam/core/service/provider/auth.dart';
import 'package:MayTeam/widget/base/appbar.dart';
import 'package:MayTeam/widget/base/scaffold.dart';
import 'package:MayTeam/widget/tile/profile_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';

import '../../core/constant/color.dart';


class ProfileScreen extends StatefulWidget{
  const ProfileScreen({super.key});
  @override
  State<StatefulWidget> createState() => ProfileScreenState();
}
class ProfileScreenState extends State<ProfileScreen> {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  DefaultCacheManager manager = new DefaultCacheManager();
  ImagePicker _picker = ImagePicker();
  FirebaseAuth _user = FirebaseAuth.instance;
  File? _photo;
  String? link;
  bool _isPhotoExist = false;
  String? _activeGroup;

  _getActiveGroup() async {
    var userData = await FirebaseFirestore.instance.collection('users').doc(_user.currentUser!.uid).get();
    var data = userData.data();
    setState(() {
      _activeGroup = data?['activeGroup'] ?? '';
    });
  }

  _uploadImage() async {
    if (_photo == null) return;
    var userID = _user.currentUser!.uid;
    final destination = '$userID';

    try {
      final ref = FirebaseStorage.instance.ref(destination).child(userID);
      await ref.putFile(_photo!);
      manager.emptyCache();
    }
    catch (e) {
      print("error occurred");
    }
  }

  _getImage() async {
    var userID = _user.currentUser!.uid;
    final destination = '$userID';
    try {
      final ref = FirebaseStorage.instance.ref(destination).child(userID);
      link = await ref.getDownloadURL();
    }
    catch (e) {
      print('error occurred on url');
    }
    if(link != null) {
      setState(() {
        _isPhotoExist = true;
      });
    }
    else {
      setState(() {
        _isPhotoExist = false;
      });
    }
  }

  _selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if(pickedFile != null) {
        _photo = File(pickedFile.path);
        _uploadImage();
      }
      else {
        print("No Image Selected.");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getImage();
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
                onTap: () async {
                  _selectImage();
                },
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
