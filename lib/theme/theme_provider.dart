import 'package:flutter/material.dart';
import 'package:social_app/theme/dark_mode.dart';
import 'package:social_app/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themedata) {
    _themeData = themedata;
    notifyListeners();
  }

  void toggleThemes() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
