import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  //Private constructor
  FirebaseService._();
  //Static constructor
  static final FirebaseService instance = FirebaseService._();

  static final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  static final CollectionReference groupCollection = FirebaseFirestore.instance.collection('groups');


  static Future createUser(String userID, String fullName, String email, String phoneNumber) async {
    return await userCollection.doc(userID).set({
      'displayName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'lastSeen': DateTime.now().millisecondsSinceEpoch,
      'profilePictureUrl': '',
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
      'friends': [],
      'blockedUsers': [],
      'chats': [],
      'settings': {
        'notifications': true,
        'darkMode': false,
        'isAdmin': false,
        'language': 'TR'
      },
    });
  }

  static Future createGroup(String userID, String groupName) async {
    DocumentReference groupDocRef = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': '',
      'members': [],
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
      'lastMessage': {},
    });

    await groupDocRef.update({
      'members': FieldValue.arrayUnion([userID]),
    });
  }

  static Future<void> togglingGroupJoin(String userID, String groupID) async {
    DocumentReference groupRef = groupCollection.doc(groupID);
    DocumentReference userRef = userCollection.doc(userID);
    DocumentSnapshot groupSnapshot = await groupCollection.doc(groupID).get();
    List<dynamic> groupMembers = await groupSnapshot.get('members');

    if(groupMembers.contains(userID)) {
      await groupRef.update({
        'members': FieldValue.arrayRemove([userID])
      });
      await userRef.update({
        'chats': FieldValue.arrayRemove([groupID])
      });
    }
    else {
      await groupRef.update({
        'members': FieldValue.arrayUnion([userID])
      });
      await userRef.update({
        'chats': FieldValue.arrayUnion([groupID])
      });
    }
  }

  static Future<bool> isUserJoined(String userID, String groupID) async {
    DocumentSnapshot groupSnapshot = await groupCollection.doc(groupID).get();
    List<dynamic> groupMembers = await groupSnapshot.get('members');

    if (groupMembers.contains(userID)) {
      return true;
    } else {
      return false;
    }
  }

  static Future<DocumentSnapshot> getUserData(String userID) async {
    DocumentSnapshot snapshot = await userCollection.doc(userID).get();
    return snapshot;
  }

  static Future<DocumentSnapshot> getGroupData(String groupID) async {
    DocumentSnapshot snapshot = await groupCollection.doc(groupID).get();
    return snapshot;
  }

  static Future<Stream<DocumentSnapshot>> getUserGroups(String userID) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .snapshots();
  }

  static Future<QuerySnapshot> getAllGroups() async {
    return groupCollection.get();
  }

  static Future<Stream<QuerySnapshot>> getChats(String groupID) async {
    return groupCollection.doc(groupID).collection('messages').orderBy('time').snapshots();
  }

  static void sendMessage(String groupID, chatMessageData) {
    FirebaseFirestore.instance.collection('groups').doc(groupID).collection('messages').add(chatMessageData);
    FirebaseFirestore.instance.collection('groups').doc(groupID).update({
      'lastMessage': {
        'content': chatMessageData['message'],
        'sender': chatMessageData['sender'],
        'timestamp': chatMessageData['time'].toString()
      },
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
}