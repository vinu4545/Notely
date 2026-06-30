import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider(this._preferences) {
    _isDarkMode = _preferences.getBool(AppConstants.themePreferenceKey) ?? false;
  }

  final SharedPreferences _preferences;
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme(bool value) {
    _isDarkMode = value;
    _preferences.setBool(AppConstants.themePreferenceKey, value);
    notifyListeners();
  }
}
