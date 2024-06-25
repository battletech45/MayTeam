import 'package:MayTeam/core/service/provider/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';


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
  bool _isLoading = false;
  File? _photo;
  String? link;
  bool _isPhotoExist = false;
  String? _activeGroup;
  bool isAdmin = false;

  _getActiveGroup() async {
    var userData = await FirebaseFirestore.instance.collection('users').doc(_user.currentUser!.uid).get();
    var data = userData.data();

    if(data!['email'] != null && data['email'] == 'taneri862@gmail.com') {
      setState(() {
        isAdmin = true;
      });
    }

    setState(() {
      _activeGroup = data['activeGroup'];
    });
  }

  _uploadImage() async {
    if (_photo == null) return;
    var userID = _user.currentUser!.uid;
    final destination = '$userID';

    try {
      setState(() {
        _isLoading = true;
      });
      final ref = FirebaseStorage.instance.ref(destination).child(userID);
      await ref.putFile(_photo!);
      setState(() {
        _isLoading = false;
      });
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.brown[900],
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: _selectImage,
          ),
        ],
        title: Text("Profile"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      body: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 50.0),
              Container(
                margin: EdgeInsets.all(15),
                child: Center(
                  child: CircleAvatar(
                    radius: 95,
                    child: _isLoading ? CircularProgressIndicator(color: Colors.red) : _isPhotoExist ? CircleAvatar(radius: 90, backgroundImage: CachedNetworkImageProvider(link!)) : Icon(Icons.person,size: 80.0),
                  ),
                ),
              ),
              SizedBox(height: 50.0),
              Container(
                height: 40,
                decoration: BoxDecoration(color:Colors.teal[900], borderRadius: BorderRadius.circular(8)),
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.person_outline_rounded,size: 25.0,),
                    SizedBox(width: 70.0,),
                    Text("${context.read<AutherProvider>().user?.displayName ?? ''}",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    SizedBox(width: 120.0,),

                  ],
                ),
              ),
              SizedBox(height: 25.0),
              Container(
                height: 40,
                decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(7)),
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: 20.0,),
                    Icon(Icons.alternate_email_rounded, size: 25.0,),
                    SizedBox(width: 50.0,),
                    Expanded(
                      child: Text("${context.read<AutherProvider>().user?.email ?? ''}",style: TextStyle(fontSize: 15),),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.0),
              Container(
                height: 40,
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(7)),
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: 20.0,),
                    Icon(Icons.games, size:25.0),
                    SizedBox(width: 100.0),
                    Expanded(
                      child: Text("$_activeGroup",style:TextStyle(fontSize: 15),),
                    ),
                  ],
                ),
              ),
            ],
     ),
    ),
    );
  }

}
