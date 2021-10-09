import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? instance;
  static Future init() async {
    instance = await SharedPreferences.getInstance();
    _defaultValues();
  }

  static void _defaultValues() {
    instance!.setBool("notification_settings_enabled", true);
    instance!.setBool("notification_settings_articles", true);
    instance!.setBool("notification_settings_substitutes_enabled", true);
    instance!.setBool(
        "notification_settings_substitutes_as_substitute_settings", true);
  }
}
