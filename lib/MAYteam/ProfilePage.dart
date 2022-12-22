import 'package:path/path.dart';
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
  File _photo;

  _getUserName() async {
    print(userName);
    print(userEmail);
    var name = await SideFunctions.getUserNameSharedPreference();
    setState(() {
      userName = name;
    });
    var email = await SideFunctions.getUserEmailSharedPreference();
    setState(() {
      userEmail = email;
    });
    print(userName);
    print(userEmail);
  }

  _uploadImage() async {
    if (_photo == null) return;
    final filename = basename(_photo.path);
    final destination = 'files/$filename';

    try {
      final ref = FirebaseStorage.instance.ref(destination).child("file/");
      await ref.putFile(_photo);
    }
    catch (e) {
      print("error occured");
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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        backgroundColor: Colors.brown[900],
        elevation: 0.0,
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
          child: ListView(
            children: <Widget>[
              Container(
                width:200,
                height: 200,
                margin: EdgeInsets.all(15),
                child: Center(
                  child: CircleAvatar(
                    radius: 78,
                    child: Icon(Icons.person,size: 80.0,),
                  ),
                ),
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(color: Colors.deepOrange[900], borderRadius: BorderRadius.circular(50)),
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                child: Center(
                 child: Text("$userName"),
                ),
              ),
              SizedBox(height: 25.0),
              Container(
                height: 40,
                decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(50)),
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                child: Center(
                  child: Text("$userEmail"),
                ),
              ),
              SizedBox(height: 25.0),
              Container(
                height: 40,
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50)),
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                child: Center(
                  child: Text("NBA 2K23"),
                ),
              ),
            ],
     ),
    ),
    );
  }

}
