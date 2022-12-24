import 'package:firebase_auth/firebase_auth.dart';
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
  FirebaseAuth _user = FirebaseAuth.instance;
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
    var userID = _user.currentUser.uid;
    final destination = '$userID/' + '$filename';

    try {
      final ref = FirebaseStorage.instance.ref(destination).child(userID);
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        backgroundColor: Color.fromRGBO(45, 64, 89,1),
        //elevation: 0.0,
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
        color: Color.fromRGBO(45, 64, 89,1),//RENK BURAYA EKLENDİ
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
              /*Container(
                height: 40,
                decoration: BoxDecoration(color: Colors.deepOrange[900], borderRadius: BorderRadius.circular(50)),
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                child: Center(
                 child: Text("$userName"),
                ),
              ), */
              Container(
                height: 40,
                decoration: BoxDecoration(/*color: Colors.deepOrange[900]*/color:Color.fromRGBO(199, 75, 80,1), borderRadius: BorderRadius.circular(8)),
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
                decoration: BoxDecoration(/*color: Colors.blueAccent*/ color:Color.fromRGBO(240, 123, 63,1) ,borderRadius: BorderRadius.circular(7)),
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
                decoration: BoxDecoration(/*color: Colors.red*/ color:Color.fromARGB(255, 212, 96,1), borderRadius: BorderRadius.circular(7)),
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: 20.0,),
                    Icon(Icons.games, size:25.0),
                    SizedBox(width: 100.0),
                    Expanded(
                      child: Text("NBA 2K23",style:TextStyle(fontSize: 15),),
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
