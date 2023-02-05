import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:MayTeam/MAYteam/SideFunctions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'GameGroupPage.dart';


class ProfilePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ProfilePageState();
}
class ProfilePageState extends State<ProfilePage> {
  String userName = '';
  String userEmail = '';
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  ImagePicker _picker = ImagePicker();
  FirebaseAuth _user = FirebaseAuth.instance;
  File _photo;
  String _photoLink;
  bool _isPhotoExist = false;
  String _activeGroup;

  _getUserName() async {
    var name = await SideFunctions.getUserNameSharedPreference();
    setState(() {
      userName = name;
    });
    var email = await SideFunctions.getUserEmailSharedPreference();
    setState(() {
      userEmail = email;
    });
  }

  _getActiveGroup() async {
    var userData = await FirebaseFirestore.instance.collection('users').doc(_user.currentUser.uid).get();
    var data = userData.data();

    setState(() {
      _activeGroup = data['activeGroup'];
    });
  }

  _uploadImage() async {
    if (_photo == null) return;
    var userID = _user.currentUser.uid;
    final destination = '$userID';

    try {
      final ref = FirebaseStorage.instance.ref(destination).child(userID);
      await ref.putFile(_photo);
    }
    catch (e) {
      print("error occurred");
    }
  }

  _getImage() async {
    var userID = _user.currentUser.uid;
    final destination = '$userID';
    String link;
    try {
      final ref = FirebaseStorage.instance.ref(destination).child(userID);
      link = await ref.getDownloadURL();
    }
    catch (e) {
      print('error occurred on url');
      print(link);
    }
    if(link != null) {
      setState(() {
        _photoLink = link;
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
    _getUserName();
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
          onPressed: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
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
                    child: _isPhotoExist ? CircleAvatar(radius: 90, backgroundImage: NetworkImage(_photoLink)) : Icon(Icons.person,size: 80.0),
                  ),
                ),
              ),
              SizedBox(height: 50.0),
              Container(
                height: 40,
                decoration: BoxDecoration(color:Colors.purple[900], borderRadius: BorderRadius.circular(8)),
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.person_outline_rounded,size: 25.0,),
                    SizedBox(width: 70.0,),
                    Text("$userName",style: TextStyle(fontSize: 15),),
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
                      child: Text("$userEmail",style: TextStyle(fontSize: 15),),
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
