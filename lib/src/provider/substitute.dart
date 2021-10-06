import 'package:engelsburg_app/src/services/shared_prefs.dart';
import 'package:flutter/cupertino.dart';

class SubstituteSettings extends ChangeNotifier {
  static final String _prefix = "substitute_settings_";
  final _prefs = SharedPrefs.instance!;

  bool get isByTimetable =>
      _prefs.getBool(_prefix + "timetable_enabled") ?? false;
  bool get isByTeacher => _prefs.getBool(_prefix + "teacher_enabled") ?? false;
  bool get isByClass => _prefs.getBool(_prefix + "class_enabled") ?? false;

  String? get byClass => _prefs.getString(_prefix + "class");
  String? get byTeacher => _prefs.getString(_prefix + "teacher");

  void setByTeacher(bool value) {
    _prefs.setBool(_prefix + "teacher_enabled", value);
    notifyListeners();
  }

  void setByClass(bool value) {
    _prefs.setBool(_prefix + "class_enabled", value);
    notifyListeners();
  }

  void setClass(String clazz) {
    _prefs.setString(_prefix + "class", clazz);
    notifyListeners();
  }

  void setTeacher(String teacher) {
    _prefs.setString(_prefix + "teacher", teacher);
    notifyListeners();
  }

  void byTimetable(bool byTimetable) {
    _prefs.setBool(_prefix + "timetable", byTimetable);
    notifyListeners();
  }
}
