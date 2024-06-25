import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  //Private constructor
  FirebaseService._();
  //Static constructor
  static final FirebaseService instance = FirebaseService._();

  static final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  static final CollectionReference groupCollection = FirebaseFirestore.instance.collection('groups');


  static Future updateUserData(String userID, String fullName, String email, String password) async {
    return await userCollection.doc(userID).set({
      'fullName': fullName,
      'email': email,
      'password': password,
      'groups': [],
      'profilePic': '',
      'activeGroup': ''
    });
  }

  static updateUserLastGroup(String userID, String groupName) async {
    return await userCollection.doc(userID).update({
      'activeGroup': groupName
    });
  }

  static updateUserPassword(String userID, String password) async {
    return await userCollection.doc(userID).update({
      'password': password
    });
  }

  static updateUserToken(String userID, String token) async {
    return await userCollection.doc(userID).update({
      'token': token
    });
  }

  static Future createGroup(String userID, String userName, String groupName, String userToken) async {
    DocumentReference groupDocRef = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': '',
      'admin': userName,
      'members': [],
      'memberTokens': [],
      'groupID': '',
      'recentMessage': '',
      'recentMessageSender': ''
    });

    await groupDocRef.update({
      'members': FieldValue.arrayUnion([userID + '_' + userName]),
      'groupID': groupDocRef.id,
      'memberTokens': FieldValue.arrayUnion([userToken])
    });

    DocumentReference userDocRef = userCollection.doc(userID);
    return await userDocRef.update({
      'groups': FieldValue.arrayUnion([groupDocRef.id + '_' + groupName])
    });
  }

  static Future<void> togglingGroupJoin(String userID, String groupID, String groupName, String userName, String token) async {
    DocumentReference userDocRef = userCollection.doc(userID);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = groupCollection.doc(groupID);

    List<dynamic> groups = await userDocSnapshot.get("groups");

    if (groups.contains(groupID + '_' + groupName)) {
      await userDocRef.update({
        'groups': FieldValue.arrayRemove([groupID + '_' + groupName])
      });

      await groupDocRef.update({
        'members': FieldValue.arrayRemove([userID + '_' + userName]),
        'memberTokens': FieldValue.arrayRemove([token])
      });
    } else {
      await userDocRef.update({
        'groups': FieldValue.arrayUnion([groupID + '_' + groupName])
      });

      await groupDocRef.update({
        'members': FieldValue.arrayUnion([userID + '_' + userName]),
        'memberTokens': FieldValue.arrayUnion([token])
      });
    }
  }

  static Future<bool> isUserJoined(String userID, String groupID, String groupName, String userName) async {
    DocumentReference userDocRef = userCollection.doc(userID);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    List<dynamic> groups = await userDocSnapshot.get("groups");

    if (groups.contains(groupID + '_' + groupName)) {
      return true;
    } else {
      return false;
    }
  }

  static Future<QuerySnapshot> getUserData(String email) async {
    QuerySnapshot snapshot =
    await userCollection.where('email', isEqualTo: email).get();
    return snapshot;
  }

  static Future<Stream<DocumentSnapshot>> getUserGroups(String userID) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .snapshots();
  }

  static Future<QuerySnapshot> getGroupMembers(String groupID) async {
    return groupCollection.where('groupID', isEqualTo: groupID).get();
  }

  static void sendMessage(String groupID, chatMessageData) {
    FirebaseFirestore.instance.collection('groups').doc(groupID).collection('messages').add(chatMessageData);
    FirebaseFirestore.instance.collection('groups').doc(groupID).update({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString()
    });
  }

  static void deleteMessage(String groupID, String messageID) {
    FirebaseFirestore.instance.collection('groups').doc(groupID).collection('messages').doc(messageID).delete();
  }

  static void editMessage(String groupID, String messageID, String newMessage) {
    groupCollection.doc(groupID).collection('messages').doc(messageID).update({
      'message': newMessage
    });
  }

  static Future<Stream<QuerySnapshot>> getChats(String groupID) async {
    return FirebaseFirestore.instance.collection('groups').doc(groupID).collection('messages').orderBy('time').snapshots();
  }

  static Future<QuerySnapshot> searchByName(String groupName) {
    return FirebaseFirestore.instance.collection('groups').where('groupName', isEqualTo: groupName).get();
  }

  static Future<Stream<QuerySnapshot>> getAllGroups() async {
    return groupCollection.snapshots();
  }
}