import 'dart:io';
import 'dart:math';

import 'package:MayTeam/core/constant/text_style.dart';
import 'package:MayTeam/core/service/firebase.dart';
import 'package:MayTeam/core/service/log.dart';
import 'package:MayTeam/core/service/provider/auth.dart';
import 'package:MayTeam/core/service/provider/theme.dart';
import 'package:MayTeam/widget/base/appbar.dart';
import 'package:MayTeam/widget/base/scaffold.dart';
import 'package:MayTeam/widget/tile/profile_tile.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/constant/color.dart';
import '../../widget/animation/animated_toggle.dart';


class ProfileScreen extends StatefulWidget{
  const ProfileScreen({super.key});
  @override
  State<StatefulWidget> createState() => ProfileScreenState();
}
class ProfileScreenState extends State<ProfileScreen> {
  String? link;
  var notifications = false;

  Future<void> _uploadImageToFirebase(File imageFile) async {
    try {
      String fileName = 'images/${context.read<AutherProvider>().user?.uid}';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

      UploadTask uploadTask = storageRef.putFile(imageFile);
      await uploadTask.whenComplete(() => {
        LoggerService.logInfo('Image file uploaded.')
      });
      String downloadUrl = await storageRef.getDownloadURL();
      context.read<AutherProvider>().user?.updateProfile(photoURL: downloadUrl).then((val) async {
        await context.read<AutherProvider>().user?.reload();
        setState(() {
          link = context.read<AutherProvider>().user?.photoURL;
        });
      });
      setState(() {
        link = downloadUrl;
      });
    }
    catch(e) {
      LoggerService.logError(e.toString());
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile != null) {
      File imageFile = File(pickedFile.path);
      _uploadImageToFirebase(imageFile);
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      link = context.read<AutherProvider>().user?.photoURL;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundImage: false,
      appBar: AppAppBar(
        isDrawer: false,
        title: 'Profil',
        actions: [
          IconButton(
              onPressed: _pickImage,
              icon: Icon(Icons.edit)
          )
        ],
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
                      child: link != null ? CircleAvatar(radius: 90, backgroundImage: CachedNetworkImageProvider(link!)) : Icon(Icons.person,size: 80.0),
                    ),
                  ),
                ),
              ),
              50.verticalSpace,
              ProfileTile(icon: Icons.person_outline_rounded, data: "${context.read<AutherProvider>().user?.displayName ?? ''}"),
              10.verticalSpace,
              ProfileTile(icon: Icons.alternate_email_rounded, data: "${context.read<AutherProvider>().user?.email ?? ''}"),
              20.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  AnimatedToggle(
                    title: 'Bildirimler',
                    current: notifications,
                    first: false,
                    second: true,
                    leftIcon: Icons.notification_important_outlined,
                    onChanged: (b) => setState(() => notifications = b!),
                  ),
                  AnimatedToggle(
                    title: 'Tema',
                    current: context.watch<ThemeProvider>().themeString == 'light',
                    first: false,
                    second: true,
                    rightText: 'Koyu',
                    leftIcon: Icons.light_outlined,
                    rightIcon: Icons.mode_night_outlined,
                    onChanged: (b) => context.read<ThemeProvider>().changeTheme()
                  ),
                ],
              )
            ],
     ),
    ),
    );
  }

}
