// ignore_for_file: deprecated_member_use, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeNotifier extends ChangeNotifier {
  ModeDataStorageService darkThemePreference = ModeDataStorageService();
  late bool _darkTheme;

  bool get darkTheme => _darkTheme;

  AppThemeNotifier(bool themeValue) {
    _darkTheme = themeValue;
    // getPreferences();
  }

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setTheme(value);
    notifyListeners();
  }

  void getPreferences() async {
    _darkTheme = await darkThemePreference.getTheme();
    notifyListeners();
  }
}

class ModeDataStorageService {
  final THEME_STATUS = "THEMESTATUS";

  setTheme(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    bool? res = prefs.getBool(THEME_STATUS);
    if (res != null && res == true) {
      return true;
    } else if (res != null && res == false) {
      return false;
    } else {
      var brightness = SchedulerBinding.instance.window.platformBrightness;
      bool isDarkMode = brightness == Brightness.dark;
      return isDarkMode;
    }
  }
}
