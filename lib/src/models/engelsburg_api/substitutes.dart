import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

final DateFormat _format = DateFormat("yyyy-MM-dd");

class Substitutes {
  Substitutes({
    this.substitutes = const [],
  });

  final List<Substitute> substitutes;

  factory Substitutes.fromJson(Map<String, dynamic> json) => Substitutes(
        substitutes: json["substitutes"] == null
            ? []
            : List<Substitute>.from(
                json["substitutes"].map((x) => Substitute.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "substitutes": List<dynamic>.from(substitutes.map((x) => x.toMap())),
      };
}

class Substitute {
  Substitute({
    this.date,
    this.className,
    this.lesson,
    this.subject,
    this.substituteTeacher,
    this.teacher,
    required this.type,
    this.substituteOf,
    this.room,
    this.text,
  });

  final DateTime? date;
  final String? className;
  final int? lesson;
  final String? subject;
  final String? substituteTeacher;
  final String? teacher;
  final SubstituteType type;
  final String? substituteOf;
  final String? room;
  final String? text;

  factory Substitute.fromJson(Map<String, dynamic> json) => Substitute(
        date: DateTime.parse(json["date"]),
        className: json["className"],
        lesson: json["lesson"],
        subject: json["subject"],
        substituteTeacher: json["substituteTeacher"],
        teacher: json["teacher"],
        type: SubstituteTypeExt.parse(json['type']),
        substituteOf: json['substituteOf'],
        room: json['room'],
        text: json['text'],
      );

  Map<String, dynamic> toMap() => {
        "date": _format.format(date!),
        "className": className,
        "lesson": lesson.toString(),
        "subject": subject,
        "substituteTeacher": substituteTeacher,
        "teacher": teacher,
        "type": type.value,
        "substituteOf": substituteOf,
        "room": room,
        "text": text,
      };
}

class SubstituteMessages {
  SubstituteMessages({
    this.substituteMessages = const [],
  });

  final List<SubstituteMessage> substituteMessages;

  factory SubstituteMessages.fromJson(Map<String, dynamic> json) =>
      SubstituteMessages(
        substituteMessages: json["substituteMessages"] == null
            ? []
            : List<SubstituteMessage>.from(json["substituteMessages"]
                .map((x) => SubstituteMessage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "substituteMessages":
            List<dynamic>.from(substituteMessages.map((x) => x.toMap())),
      };
}

class SubstituteMessage {
  SubstituteMessage({
    this.date,
    this.absenceTeachers,
    this.absenceClasses,
    this.affectedClasses,
    this.affectedRooms,
    this.blockedRooms,
    this.messages,
  });

  final DateTime? date;
  final String? absenceTeachers;
  final String? absenceClasses;
  final String? affectedClasses;
  final String? affectedRooms;
  final String? blockedRooms;
  final String? messages;

  factory SubstituteMessage.fromJson(Map<String, dynamic> json) =>
      SubstituteMessage(
        date: DateTime.parse(json["date"]),
        absenceTeachers: json["absenceTeachers"],
        absenceClasses: json["absenceClasses"],
        affectedClasses: json["affectedClasses"],
        affectedRooms: json["affectedRooms"],
        blockedRooms: json["blockedRooms"],
        messages: json['messages'],
      );

  Map<String, dynamic> toMap() => {
        "date": _format.format(date!),
        "absenceTeachers": absenceTeachers,
        "absenceClasses": absenceClasses,
        "affectedClasses": affectedClasses,
        "affectedRooms": affectedRooms,
        "blockedRooms": blockedRooms,
        "messages": messages,
      };
}

enum SubstituteType {
  canceled,
  independentWork,
  substitute,
  roomSubstitute,
  care,
}

extension SubstituteTypeExt on SubstituteType {
  String name(BuildContext context) {
    switch (this) {
      case SubstituteType.canceled:
        return AppLocalizations.of(context)!.substituteTypeCanceled;
      case SubstituteType.independentWork:
        return AppLocalizations.of(context)!.substituteTypeIndependentWork;
      case SubstituteType.roomSubstitute:
        return AppLocalizations.of(context)!.substituteTypeRoomSubstitute;
      case SubstituteType.care:
        return AppLocalizations.of(context)!.substituteTypeCare;
      case SubstituteType.substitute:
        return AppLocalizations.of(context)!.substituteTypeSubstitute;
    }
  }

  static SubstituteType parse(String toParse) {
    switch (toParse) {
      case "Entfall":
        return SubstituteType.canceled;
      case "eigenv. Arb.":
        return SubstituteType.independentWork;
      case "Raum-Vtr.":
        return SubstituteType.roomSubstitute;
      case "Betreuung":
        return SubstituteType.care;
      default:
        return SubstituteType.substitute;
    }
  }

  String get value {
    switch (this) {
      case SubstituteType.canceled:
        return "Entfall";
      case SubstituteType.independentWork:
        return "eigenv. Arb.";
      case SubstituteType.roomSubstitute:
        return "Raum-Vtr.";
      case SubstituteType.care:
        return "Betreuung";
      case SubstituteType.substitute:
        return "Vertretung";
    }
  }

  int get priority {
    switch (this) {
      case SubstituteType.canceled:
        return 4;
      case SubstituteType.independentWork:
        return 3;
      case SubstituteType.care:
        return 2;
      case SubstituteType.substitute:
        return 1;
      case SubstituteType.roomSubstitute:
        return 0;
    }
  }
}
