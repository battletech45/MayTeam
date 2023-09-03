import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFunctions {
  final String? userID;

  FirebaseFunctions({
    this.userID,
  });

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');

  Future updateUserData(String fullName, String email, String password, String token) async {
    return await userCollection.doc(userID).set({
      'fullName': fullName,
      'email': email,
      'password': password,
      'groups': [],
      'profilePic': '',
      'activeGroup': '',
      'token': token
    });
  }

  updateUserLastGroup(String groupName) async {
    print(userID);
    return await userCollection.doc(userID).update({
      'activeGroup': groupName
    });
  }

  updateUserPassword(String password) async {
    print(userID);
    return await userCollection.doc(userID).update({
      'password': password
    });
  }

  Future createGroup(String userName, String groupName) async {
    DocumentReference groupDocRef = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': '',
      'admin': userName,
      'members': [],
      'groupID': '',
      'recentMessage': '',
      'recentMessageSender': ''
    });

    await groupDocRef.update({
      'members': FieldValue.arrayUnion([userID! + '_' + userName]),
      'groupID': groupDocRef.id
    });

    DocumentReference userDocRef = userCollection.doc(userID);
    return await userDocRef.update({
      'groups': FieldValue.arrayUnion([groupDocRef.id + '_' + groupName])
    });
  }

  Future<void> togglingGroupJoin(
      String groupID, String groupName, String userName, String token) async {
    DocumentReference userDocRef = userCollection.doc(userID);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = groupCollection.doc(groupID);

    List<dynamic> groups = await userDocSnapshot.get("groups");

    if (groups.contains(groupID + '_' + groupName)) {
      await userDocRef.update({
        'groups': FieldValue.arrayRemove([groupID + '_' + groupName])
      });

      await groupDocRef.update({
        'members': FieldValue.arrayRemove([userID! + '_' + userName]),
        'tokens': FieldValue.arrayRemove([token])
      });
    } else {
      await userDocRef.update({
        'groups': FieldValue.arrayUnion([groupID + '_' + groupName])
      });

      await groupDocRef.update({
        'members': FieldValue.arrayUnion([userID! + '_' + userName]),
        'tokens': FieldValue.arrayUnion([token])
      });
    }
  }

  Future<bool> isUserJoined(
      String groupID, String groupName, String userName) async {
    DocumentReference userDocRef = userCollection.doc(userID);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    List<dynamic> groups = await userDocSnapshot.get("groups");

    if (groups.contains(groupID + '_' + groupName)) {
      return true;
    } else {
      return false;
    }
  }

   Future<QuerySnapshot> getUserData(String email) async {
      QuerySnapshot snapshot =
          await userCollection.where('email', isEqualTo: email).get();
      return snapshot;
  }

  Future<Stream<DocumentSnapshot>> getUserGroups() async {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .snapshots();
  }

  Future<Stream<DocumentSnapshot>> getGroupMembers(String groupID) async {
      return FirebaseFirestore.instance.collection('groups').doc(groupID).snapshots();
  }

  void sendMessage(String groupID, chatMessageData) {
    FirebaseFirestore.instance
        .collection('groups')
        .doc(groupID)
        .collection('messages')
        .add(chatMessageData);
    FirebaseFirestore.instance.collection('groups').doc(groupID).update({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString()
    });
  }

  void deleteMessage(String groupID, String messageID) {
    FirebaseFirestore.instance.collection('groups').doc(groupID).collection('messages').doc(messageID).delete();
  }
  void editMessage(String groupID, String messageID, String newMessage) {
    groupCollection.doc(groupID).collection('messages').doc(messageID).update({
      'message': newMessage
    });
  }

  Future<Stream<QuerySnapshot>> getChats(String groupID) async {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupID)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  Future<QuerySnapshot> searchByName(String groupName) {
    return FirebaseFirestore.instance
        .collection('groups')
        .where('groupName', isEqualTo: groupName)
        .get();
  }

  Future<Stream<QuerySnapshot>> getAllGroups() async {
    return groupCollection.snapshots();
  }
}
