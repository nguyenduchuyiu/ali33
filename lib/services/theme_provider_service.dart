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
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    await _prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    bool? res = _prefs.getBool(THEME_STATUS);
    if (res != null && res == true) {
      return true;
    } else if (res != null && res == false) {
      return false;
    } else {
      var brightness = SchedulerBinding.instance!.window.platformBrightness;
      bool isDarkMode = brightness == Brightness.dark;
      return isDarkMode;
    }
  }
}
