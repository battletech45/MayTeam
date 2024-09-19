import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/theme.dart';

class ThemeProvider extends ChangeNotifier {
  bool isInit = true;
  ThemeData selected = AppTheme.lightTheme;
  String themeString;
  ThemeProvider({required this.themeString});

  void init(BuildContext context) {
    if(isInit) {
      switch (themeString) {
        case 'dark':
          selected = AppTheme.darkTheme;
        case 'light':
          selected = AppTheme.lightTheme;
        case 'platform':
          final platform = MediaQuery.of(context).platformBrightness;
          if(platform == Brightness.dark) {
            selected = AppTheme.darkTheme;
          }
          else {
            selected = AppTheme.lightTheme;
          }
        default:
          selected = AppTheme.lightTheme;
      }
      isInit = false;
    }
  }

  void changeTheme() {
    if(selected == AppTheme.lightTheme) {
      selected = AppTheme.darkTheme;
      themeString = 'dark';
      _writeShared('dark');
    }
    else {
      selected = AppTheme.lightTheme;
      themeString = 'light';
      _writeShared('light');
    }
    notifyListeners();
  }

  Future<bool> _writeShared(String value) async {
    final pref = await SharedPreferences.getInstance();
    bool b = await pref.setString('theme', value);
    return b;
  }

  String themeText() {
    switch (themeString) {
      case 'dark':
        return 'Koyu';
      case 'light':
        return 'Açık';
      case 'platform':
        return 'Cihaz Teması';
      default:
        return 'Bilinmeyen';
    }
  }
}