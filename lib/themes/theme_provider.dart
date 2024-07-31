import 'package:flutter/material.dart';
import 'package:habittracker/themes/themes.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData getThemeData() {
    return _themeData;
  }

  void setThemeData(ThemeData newTheme) {
    _themeData = newTheme;
  }

  bool isDark() {
    if (_themeData == lightMode) {
      return false;
    } else {
      return true;
    }
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }
    notifyListeners();
  }
}
