import 'package:engelsburg_app/src/utils/string_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  static int compare(Substitute a, Substitute b) {
    //compare date
    if (a.date != null && b.date != null) {
      int compare = a.date!.compareTo(b.date!);
      if (compare != 0) return compare;
    }

    //compare class
    if (a.className != null &&
        b.className != null &&
        a.className != b.className) {
      //Q1 Q1 => false, //Q1 E1 => true, //Q1 Q1Q3 => true

      var aClassName = a.className!, bClassName = b.className!;
      var aFirst = aClassName[0], bFirst = bClassName[0];
      bool aNum = StringUtils.isNumeric(aFirst),
          bNum = StringUtils.isNumeric(bFirst);

      if (aNum && bNum) {
        //5a 8c => true, //Q1 5c => false, //Q1 E1 => false

        if (aFirst != bFirst) {
          //8a 5c => true, //9ac 6d => true

          return int.parse(aFirst).compareTo(int.parse(bFirst));
        } else {
          //5a 5b => true, //5a 5abc => true

          if (aClassName.length < bClassName.length) {
            //5c 5abc => true

            return -1;
          } else if (aClassName.length > bClassName.length) {
            //5abc 5c => true

            return 1;
          } else {
            //5c 5b => true, //7c 7a => true, //9abc 9ade => true

            int aVal = 0, bVal = 0;
            for (var rune in aClassName.runes) {
              aVal += rune;
            }
            for (var rune in bClassName.runes) {
              bVal += rune;
            }

            return aVal.compareTo(bVal);
          }
        }
      } else if (!aNum && !bNum) {
        //Q1 5c => false, //Q1 E1 => true

        if (aFirst != bFirst) {
          //Q1 E1 => true, //E1 Q1 => true, //Q1 Q3 => false

          return aFirst == "Q" ? 1 : -1;
          //Q1 E1 => true -> 1
          //E1 Q1 => false -> -1
        } else {
          //Q1 Q3 => true, //Q1 Q1Q3 => true, //E1Q1Q3 E1 => true

          if (aClassName.length < bClassName.length) {
            //Q1 Q1Q3 => true

            return -1;
          } else if (aClassName.length > bClassName.length) {
            //E1Q1Q3 E1 => true

            return 1;
          } else {
            //Q1 Q3 => true, //E1 E2 => true, //Q1Q2 Q1Q2 => true, //Q1Q2 Q2Q4 => true
            int aVal = 0, bVal = 0;
            for (var rune in aClassName.runes) {
              aVal += rune;
            }
            for (var rune in bClassName.runes) {
              bVal += rune;
            }

            return aVal.compareTo(bVal);
          }
        }
      } else {
        //Q1 5c => true

        return aNum ? -1 : 1;
        //Q1 5c => false -> 1
        //5c Q1 => true -> -1
      }
    }

    //compare lessons
    if (a.lesson != null && b.lesson != null && a.lesson! != b.lesson!) {
      //5 5-6 => true, //5-6 5-6 => false, //5-6 5 => true, //5 5 => false, //5 6 => true

      return int.parse(a.lesson![0]) > int.parse(b.lesson![0]) ||
              a.lesson!.length > b.lesson!.length
          ? 1
          : -1;
      //5 5-6 => false false => false -> -1
      //5-6 5 => false true => true -> 1
      //5 6 => false false => false -> -1
      //6 5 => true false => true -> 1
    }

    //compare type
    return b.type.priority.compareTo(a.type.priority);
  }

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
  final String? lesson;
  final String? subject;
  final String? substituteTeacher;
  final String? teacher;
  final SubstituteType type;
  final String? substituteOf;
  final String? room;
  final String? text;

  factory Substitute.fromJson(Map<String, dynamic> json) => Substitute(
        date: json["date"],
        className: json["className"],
        lesson: json["lesson"],
        subject: json["subject"],
        substituteTeacher: json["substituteTeacher"],
        teacher: json["teacher"],
        type: json['type'],
        substituteOf: json['substituteOf'],
        room: json['room'],
        text: json['text'],
      );

  Map<String, dynamic> toMap() => {
        "date": date,
        "className": className,
        "lesson": lesson,
        "subject": subject,
        "substituteTeacher": substituteTeacher,
        "teacher": teacher,
        "type": type,
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
        date: json["date"],
        absenceTeachers: json["absenceTeachers"],
        absenceClasses: json["absenceClasses"],
        affectedClasses: json["affectedClasses"],
        affectedRooms: json["affectedRooms"],
        blockedRooms: json["blockedRooms"],
        messages: json['messages'],
      );

  Map<String, dynamic> toMap() => {
        "date": date,
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
