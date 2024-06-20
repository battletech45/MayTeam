import 'package:MayTeam/core/service/firebase.dart';
import 'package:MayTeam/core/service/log.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/service/provider/auth.dart';
import 'SideFunctions.dart';

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

  static Future registerWithEmailAndPassword(String fullName, String email, String password, String token) async {
    try {
      UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      await FirebaseService.updateUserData(context.read<AutherProvider>().user!.uid, fullName, email, password, token);
      return user;
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }

  static Future signOut() async {
    try {
      await SideFunctions.saveUserLoggedInSharedPreference(false);
      await SideFunctions.saverUserEmailSharedPreference('');
      await SideFunctions.saveUserNameSharedPreference('');

      return await FirebaseAuth.instance.signOut().whenComplete(() async {
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