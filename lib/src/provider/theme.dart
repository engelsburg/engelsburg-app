import 'package:engelsburg_app/src/services/shared_prefs.dart';
import 'package:flutter/material.dart';

class ThemeChanger extends ChangeNotifier {
  static final _prefs = SharedPrefs.instance;

  ThemeMode get themeMode {
    final themeModeSetting = _prefs!.getString('theme_mode');
    switch (themeModeSetting) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  Color? get primaryColor => _prefs!.getInt('primary_color') != null
      ? Color(_prefs!.getInt('primary_color') as int)
      : null;

  Color? get secondaryColor => _prefs!.getInt('secondary_color') != null
      ? Color(_prefs!.getInt('secondary_color') as int)
      : null;

  void enableDarkMode() async {
    await _prefs!.setString('theme_mode', 'dark');
    notifyListeners();
  }

  void disableDarkMode() async {
    await _prefs!.setString('theme_mode', 'light');
    notifyListeners();
  }

  // this will set the system default theme mode
  void clearDarkModeSetting() async {
    await _prefs!.remove('theme_mode');
    notifyListeners();
  }

  void setPrimaryColor(Color color) async {
    await _prefs!.setInt('primary_color', color.value);
    notifyListeners();
  }

  void clearPrimaryColor() async {
    await _prefs!.remove('primary_color');
    notifyListeners();
  }

  void setSecondaryColor(Color color) async {
    await _prefs!.setInt('secondary_color', color.value);
    notifyListeners();
  }

  void clearSecondaryColor() async {
    await _prefs!.remove('secondary_color');
    notifyListeners();
  }
}
