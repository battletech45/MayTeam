import 'package:firebase_auth/firebase_auth.dart';
import 'SideFunctions.dart';
import 'Firebase_functions.dart';

class ModelUser {
  final String userID;

  ModelUser({
    this.userID
  });
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ModelUser _userFromFirebaseUser(User user) {
    return (user != null) ? ModelUser(userID: user.uid) : null;
  }

  Future signInWithEmailAndPassWord(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(String fullName, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;

      await FirebaseFunctions(userID: user.uid).updateUserData(fullName, email, password);
      return _userFromFirebaseUser(user);
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      await SideFunctions.saveUserLoggedInSharedPreference(false);
      await SideFunctions.saverUserEmailSharedPreference('');
      await SideFunctions.saveUserNameSharedPreference('');

      return await _auth.signOut().whenComplete(() async {
        print("Logged out");
        await SideFunctions.getUserLoggedInSharedPreference().then((value) {
          print("Logged in: $value");
        });
        await SideFunctions.getUserEmailSharedPreference().then((value) {
          print("Email: $value");
        });
        await SideFunctions.getUserNameSharedPreference().then((value) {
          print("Name: $value");
        });
      });
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }
}