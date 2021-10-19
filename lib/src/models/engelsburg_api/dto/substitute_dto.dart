import 'package:engelsburg_app/src/utils/string_utils.dart';
import 'package:intl/intl.dart';

import '../substitutes.dart';

class SubstituteDTO {
  static int compare(SubstituteDTO a, SubstituteDTO b) {
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

  SubstituteDTO({
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

  final DateFormat _format = DateFormat("yyyy-MM-dd");

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

  factory SubstituteDTO.fromSubstitute(Substitute substitute,
          {String? lesson, String? text}) =>
      SubstituteDTO(
        date: substitute.date,
        className: substitute.className,
        lesson: lesson ?? substitute.lesson.toString(),
        subject: substitute.subject,
        substituteTeacher: substitute.substituteTeacher,
        teacher: substitute.teacher,
        type: substitute.type,
        substituteOf: substitute.substituteOf,
        room: substitute.room,
        text: text ?? substitute.text,
      );

  factory SubstituteDTO.fromJson(Map<String, dynamic> json) => SubstituteDTO(
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
        "lesson": lesson,
        "subject": subject,
        "substituteTeacher": substituteTeacher,
        "teacher": teacher,
        "type": type.value,
        "substituteOf": substituteOf,
        "room": room,
        "text": text,
      };
}
