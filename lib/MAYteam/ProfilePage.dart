import 'package:flutter/material.dart';
import 'GameGroupPage.dart';


class ProfilePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ProfilePageState();
}
class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        backgroundColor: Colors.brown[900],
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
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
            children: [
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
                margin: EdgeInsets.all(15),
                color: Colors.amber,
                child: Center(
                 child: Text("Yarkın Ata", selectionColor: Colors.pink,),
                ),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.all(15),
                color: Colors.blueAccent,
                child: Center(
                  child: Text("dasda@gmail.com", selectionColor: Colors.black45,),
                ),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.all(15),
                color: Colors.red,
                child: Center(
                  child: Text("NBA 2K23", selectionColor: Colors.yellowAccent,),
                ),
              ),
            ],
     ),
    ),
    );
  }

}
