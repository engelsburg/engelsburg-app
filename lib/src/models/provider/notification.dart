import 'package:engelsburg_app/src/services/shared_prefs.dart';
import 'package:flutter/cupertino.dart';

class NotificationSettings extends ChangeNotifier {
  static const String _prefix = "notification_settings_";
  final _prefs = SharedPrefs.instance!;
  late final SubstituteNotificationSettings _substitutesNotificationSettings;

  void _recallNotifyListeners() => notifyListeners();

  NotificationSettings() {
    _substitutesNotificationSettings =
        SubstituteNotificationSettings(_recallNotifyListeners);
  }

  SubstituteNotificationSettings get substitutes =>
      _substitutesNotificationSettings;

  bool get enabled => _prefs.getBool(_prefix + "enabled") ?? false;
  bool get articles => _prefs.getBool(_prefix + "article") ?? false;
  bool get error => _prefs.getBool(_prefix + "error") ?? false;

  void setEnabled(bool value) {
    _prefs.setBool(_prefix + "enabled", value);
    notifyListeners();
  }

  void setArticles(bool value) {
    _prefs.setBool(_prefix + "article", value);
    notifyListeners();
  }

  void setError(bool value) {
    _prefs.setBool(_prefix + "error", value);
    notifyListeners();
  }
}

class SubstituteNotificationSettings {
  static const String _prefix = "notification_settings_substitutes_";
  final _prefs = SharedPrefs.instance!;
  final VoidCallback _notifyListeners;

  SubstituteNotificationSettings(this._notifyListeners);

  bool get enabled => _prefs.getBool(_prefix + "enabled") ?? false;
  bool get asSubstituteSettings =>
      _prefs.getBool(_prefix + "as_substitute_settings") ?? false;
  bool get isByClass => _prefs.getBool(_prefix + "class_enabled") ?? false;
  bool get isByTeacher => _prefs.getBool(_prefix + "teacher_enabled") ?? false;
  bool get isByTimetable =>
      _prefs.getBool(_prefix + "timetable_enabled") ?? false;

  List<String> get classes => _prefs.getStringList(_prefix + "class") ?? [];
  List<String> get teacher => _prefs.getStringList(_prefix + "teacher") ?? [];

  void setEnabled(bool value) {
    _prefs.setBool(_prefix + "enabled", value);
    _notifyListeners();
  }

  void setAsSubstituteSettings(bool value) {
    _prefs.setBool(_prefix + "as_substitute_settings", value);
    _notifyListeners();
  }

  void setByClass(bool value) {
    _prefs.setBool(_prefix + "class_enabled", value);
    _notifyListeners();
  }

  void setByTeacher(bool value) {
    _prefs.setBool(_prefix + "teacher_enabled", value);
    _notifyListeners();
  }

  void setByTimetable(bool byTimetable) {
    _prefs.setBool(_prefix + "timetable_enabled", byTimetable);
    _notifyListeners();
  }

  void setClasses(List<String> classes) {
    _prefs.setStringList(_prefix + "class", classes);
    _notifyListeners();
  }

  void setTeacher(List<String> teacher) {
    _prefs.setStringList(_prefix + "teacher", teacher);
    _notifyListeners();
  }
}
