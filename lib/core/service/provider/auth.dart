import 'package:MayTeam/core/service/log.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/login.dart';
import '../firebase.dart';

class AutherProvider with ChangeNotifier {
  User? user;
  LoginModel? loginModel;
  final _loginKey = 'login';

  bool get isAuth => user != null;

  Future<void> init() async {
    loginModel = await _readShared();
    if (loginModel != null) {
      await login(loginModel!);
    }
  }

  Future<LoginModel?> _readShared() async {
    LoggerService.logInfo('Starting to read Shared');
    final pref = await SharedPreferences.getInstance();
    if (pref.containsKey(_loginKey)) {
      final tmpJson = pref.getString(_loginKey);
      LoggerService.logInfo('$_loginKey key exists. jsonString: $tmpJson');
      if (tmpJson != null) {
        final model = LoginModel.fromJson(tmpJson);
        LoggerService.logInfo('$_loginKey key is NOT null. loginModel: $model');
        return model;
      }
    }
    LoggerService.logInfo('Reading completed. No loginModel in Shared');
    return null;
  }

  Future<bool> writeShared(LoginModel model) async {
    LoggerService.logInfo('Starting to write Shared $model');
    final pref = await SharedPreferences.getInstance();
    bool b = await pref.setString(_loginKey, model.toJson());
    LoggerService.logInfo('Writing completed. success: $b');
    notifyListeners();
    return b;
  }

  Future<User?> signInWithEmailAndPassWord(String email, String password) async {
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

  Future<User?> registerWithEmailAndPassword(String fullName, String email, String password, String phoneNumber) async {
    try {
      UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      if(user != null) {
        await user.updateProfile(displayName: fullName);
        user = await signInWithEmailAndPassWord(email, password);
        await FirebaseService.createUser(user!.uid, fullName, email, phoneNumber);
        return user;
      }
      else {
        return null;
      }
    }
    catch(e) {
      LoggerService.logError(e.toString());
      return null;
    }
  }

  Future<bool> _clearLogin() async {
    user = null;
    LoggerService.logInfo('Starting to clear login model in shared');
    final pref = await SharedPreferences.getInstance();
    bool b = await pref.remove(_loginKey);
    LoggerService.logInfo('Clear completed. success: $b');
    return b;
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await _clearLogin();
      notifyListeners();
    }
    catch(e) {
      print(e.toString());
    }
  }

  Future<String?> login(LoginModel model) async {
    final tmp = await signInWithEmailAndPassWord(model.email, model.password);
    if (tmp != null) {
      user = tmp;
      await writeShared(model);
      notifyListeners();
      return null;
    }
    return 'Kullanıcı Adı veya Şifre Hatalı';
  }

  Future<String?> register(String name, LoginModel model, String phoneNumber,) async {
    final tmp = await registerWithEmailAndPassword(name, model.email, model.password, phoneNumber);
    if (tmp != null) {
      user = tmp;
      await writeShared(model);
      notifyListeners();
      return null;
    }
    return 'Kullanıcı Adı veya Şifre Hatalı';
  }
}