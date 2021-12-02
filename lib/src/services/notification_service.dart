import 'package:engelsburg_app/src/models/provider/notification.dart';
import 'package:engelsburg_app/src/models/provider/substitute.dart';
import 'package:firebase_messaging/firebase_messaging.dart'
    hide NotificationSettings;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum NotificationType {
  article,
  substitute,
  error,
}
enum SubstituteNotificationType {
  classes,
  teacher,
}

class NotificationService {
  static final _messaging = FirebaseMessaging.instance;
  static final substitutes = SubstituteNotificationService();

  static void all(BuildContext context, bool enabled) async {
    final permissionsGranted = await _requestPermission(_messaging);
    if (!permissionsGranted) return;

    for (var type in NotificationType.values) {
      changeState(context, type, enabled);
    }
  }

  //is called when all are turned on/off
  static void changeState(
      BuildContext context, NotificationType type, bool enabled) async {
    final permissionsGranted = await _requestPermission(_messaging);
    if (!permissionsGranted) return;

    String? key;
    switch (type) {
      case NotificationType.article:
        key = 'article';
        break;
      case NotificationType.error:
        key = 'error';
        break;
      case NotificationType.substitute:
        substitutes.changeState(context, enabled);
        break;
    }

    if (key != null) {
      if (enabled) {
        await _messaging.subscribeToTopic(key);
      } else {
        await _messaging.unsubscribeFromTopic(key);
      }
    }
  }
}

class SubstituteNotificationService {
  static final _messaging = FirebaseMessaging.instance;
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

  void set(SubstituteNotificationType type, String value, bool enabled) async {
    final permissionsGranted = await _requestPermission(_messaging);
    if (!permissionsGranted) return;

    String key;
    switch (type) {
      case SubstituteNotificationType.classes:
        key = 'class';
        break;
      case SubstituteNotificationType.teacher:
        key = 'teacher';
        break;
    }

    key = '$key.${_replaceUmlaute(value)}';
    if (enabled) {
      await _messaging.subscribeToTopic(key);
    } else {
      await _messaging.unsubscribeFromTopic(key);
    }
  }

  void add(SubstituteNotificationType type, String value) {
    set(type, value, true);
  }

  void remove(SubstituteNotificationType type, String value) {
    set(type, value, false);
  }

  void all(BuildContext context, SubstituteNotificationType type,
      bool enabled) async {
    final permissionsGranted = await _requestPermission(_messaging);
    if (!permissionsGranted) return;

    var settings = context.read<NotificationSettings>().substitutes;

    List<String> values = [];
    if (!settings.asSubstituteSettings) {
      if (type == SubstituteNotificationType.classes) {
        values.addAll(settings.classes);
      } else {
        values.addAll(settings.teacher);
      }
    } else {
      var settings = context.read<SubstituteSettings>();
      if (type == SubstituteNotificationType.classes) {
        values.addAll(settings.classes);
      } else {
        values.addAll(settings.teacher);
      }
    }

    for (var value in values) {
      set(type, value, enabled);
    }
  }

  //is called when all are turned on/off
  void changeState(BuildContext context, bool enabled) async {
    final permissionsGranted = await _requestPermission(_messaging);
    if (!permissionsGranted) return;

    for (var type in SubstituteNotificationType.values) {
      all(context, type, enabled);
    }
  }
}

Future<bool> _requestPermission(FirebaseMessaging messaging) async {
  final settings = await messaging.requestPermission();

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    return true;
  }
  return false;
}
