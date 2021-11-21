import 'package:firebase_messaging/firebase_messaging.dart';

import 'shared_prefs.dart';

enum NotificationType { classNotification, teacherNotification }
enum NotificationStateAction { enable, disable }

class NotificationService {
  static final _messaging = FirebaseMessaging.instance;
  static final _prefs = SharedPrefs.instance;
  static const _umlaute = {
    "Ä": "AE",
    "Ü": "UE",
    "Ö": "OE",
    "ä": "ae",
    "ü": "ue",
    "ö": "oe",
  };

  static String _replaceUmlaute(String value) {
    final _value = value.replaceAllMapped(RegExp('[ÄÖÜäöü]'), (match) {
      return _umlaute[match[0]]!;
    });
    return _value;
  }

  static Future<bool> _requestPermission() async {
    final settings = await _messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      return true;
    }
    return false;
  }

  static void add(NotificationType type, String value) async {
    final permissionsGranted = await _requestPermission();
    if (!permissionsGranted) return;

    final prefix =
        type == NotificationType.classNotification ? 'class' : 'teacher';

    await _messaging.subscribeToTopic('$prefix.${_replaceUmlaute(value)}');
  }

  static void remove(NotificationType type, String value) async {
    final permissionsGranted = await _requestPermission();
    if (!permissionsGranted) return;

    final prefix =
        type == NotificationType.classNotification ? 'class' : 'teacher';

    await _messaging.unsubscribeFromTopic('$prefix.${_replaceUmlaute(value)}');
  }

  // is called when the notifications are turned on/off
  static void changeState(
      NotificationType type, NotificationStateAction action) async {
    final permissionsGranted = await _requestPermission();
    if (!permissionsGranted) return;

    String prefix;
    List<String> values;

    if (type == NotificationType.classNotification) {
      prefix = 'class';
      values = _prefs!.getStringList('substitute_settings_class') ?? [];
    } else {
      prefix = 'teacher';
      values = _prefs!.getStringList('substitute_settings_teacher') ?? [];
    }

    for (var value in values) {
      final _value = _replaceUmlaute(value);

      if (action == NotificationStateAction.enable) {
        await _messaging.subscribeToTopic('$prefix.$_value');
      } else {
        await _messaging.unsubscribeFromTopic('$prefix.$_value');
      }
    }
  }
}
