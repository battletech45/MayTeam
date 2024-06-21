import 'package:MayTeam/core/service/firebase.dart';
import 'package:MayTeam/core/service/log.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  const AuthService._();

  static Future<User?> signInWithEmailAndPassWord(String email, String password) async {
    try {
      UserCredential result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      if(user != null) {
        return user;
      }
      else {
        return null;
      }
    }
    catch(e) {
      LoggerService.logError(e.toString());
      rethrow;
    }
  }

  static Future<User?> registerWithEmailAndPassword(String fullName, String email, String password, String token) async {
    try {
      UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      if(user != null) {
        await FirebaseService.updateUserData(user.uid, fullName, email, password, token);
        return user;
      }
      else {
        return null;
      }
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }

  static Future<void> signOut() async {
    try {
      return await FirebaseAuth.instance.signOut();
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }
}