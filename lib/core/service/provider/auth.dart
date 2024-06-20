import 'package:MayTeam/MAYteam/Auth_functions.dart';
import 'package:MayTeam/core/service/log.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/login.dart';

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

  Future<String?> login(LoginModel model) async {
    final tmp = await AuthService.signInWithEmailAndPassWord(model.email, model.password);
    if (tmp != null) {
      user = tmp;
      await writeShared(model);
      notifyListeners();
      return null;
    }
    return 'Kullanıcı Adı veya Şifre Hatalı';
  }
}