import 'package:engelsburg_app/src/services/shared_prefs.dart';
import 'package:flutter/cupertino.dart';

class SubstituteSettings extends ChangeNotifier {
  static const String _prefix = "substitute_settings_";
  final _prefs = SharedPrefs.instance!;

  bool get isByClass => _prefs.getBool(_prefix + "class_enabled") ?? false;
  bool get isByTeacher => _prefs.getBool(_prefix + "teacher_enabled") ?? false;
  bool get isByTimetable =>
      _prefs.getBool(_prefix + "timetable_enabled") ?? false;

  List<String>? get classes => _prefs.getStringList(_prefix + "class");
  List<String>? get teacher => _prefs.getStringList(_prefix + "teacher");

  void setByClass(bool value) {
    _prefs.setBool(_prefix + "class_enabled", value);
    notifyListeners();
  }

  void setByTeacher(bool value) {
    _prefs.setBool(_prefix + "teacher_enabled", value);
    notifyListeners();
  }

  void setByTimetable(bool byTimetable) {
    _prefs.setBool(_prefix + "timetable_enabled", byTimetable);
    notifyListeners();
  }

  void setClasses(List<String> classes) {
    _prefs.setStringList(_prefix + "class", classes);
    notifyListeners();
  }

  void setTeacher(List<String> teacher) {
    _prefs.setStringList(_prefix + "teacher", teacher);
    notifyListeners();
  }
}
