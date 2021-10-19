import 'package:engelsburg_app/src/models/engelsburg_api/substitutes.dart';

///Class for test objects
class Test {
  /// Substitute messages to test layout
  ///
  /// Result.of(testSubstituteMessages.toJson())
  static final SubstituteMessages testSubstituteMessages =
      SubstituteMessages(substituteMessages: [
    SubstituteMessage(
      date: DateTime.parse("2020-07-02"),
      absenceTeachers: "GRB, JUP, MÜM, MUE (1-5), SEI (5-6)",
      affectedClasses: "5a, 5c, 7d, 8a, 8c, 8e, 9b, 9d, 10d, E1, Q1, Q3",
      affectedRooms:
          "H 101, H 103, H 301, S 202, S 301, S 302, S 304, S 402, S 404, S 405, A 301, R 203, R 204",
      blockedRooms: "H 103, H 301",
      messages: "Musik AG fällt heute aus!",
    ),
    SubstituteMessage(
      date: DateTime.parse("2020-07-02"),
      absenceTeachers: "GRB, JUP, MÜM, MUE (1-5), SEI (5-6)",
      affectedClasses: "5a, 5c, 7d, 8a, 8c, 8e, 9b, 9d, 10d, E1, Q1, Q3",
      affectedRooms:
          "H 101, H 103, H 301, S 202, S 301, S 302, S 304, S 402, S 404, S 405, A 301, R 203, R 204",
      blockedRooms: "H 103, H 301",
      messages: "Musik AG fällt heute aus!",
    ),
  ]);

  /// Substitutes to test layout
  ///
  /// Result.of(testSubstitutes.toJson())
  static final Substitutes testSubstitutes = Substitutes(substitutes: [
    Substitute(
      date: DateTime.parse("2020-09-19"),
      className: "5c",
      lesson: 6,
      subject: "M",
      substituteTeacher: "EIC",
      teacher: "KRÄ",
      type: SubstituteTypeExt.parse("Vertretung"),
      room: "H001",
    ),
    Substitute(
      date: DateTime.parse("2020-10-19"),
      className: "5a",
      lesson: 6,
      subject: "M",
      substituteTeacher: "EIC",
      teacher: "KRÄ",
      type: SubstituteTypeExt.parse("Vertretung"),
      room: "H001",
    ),
    Substitute(
      date: DateTime.parse("2020-10-19"),
      className: "5a",
      lesson: 6,
      subject: "M",
      substituteTeacher: "EIC",
      teacher: "KRÄ",
      type: SubstituteTypeExt.parse("Entfall"),
      room: "H001",
    ),
    Substitute(
      date: DateTime.parse("2020-10-19"),
      className: "5a",
      lesson: 6,
      subject: "M",
      substituteTeacher: "EIC",
      teacher: "KRÄ",
      type: SubstituteTypeExt.parse("eigenv. Arb."),
      room: "H001",
    ),
    Substitute(
      date: DateTime.parse("2020-10-19"),
      className: "5a",
      lesson: 6,
      subject: "M",
      substituteTeacher: "EIC",
      teacher: "KRÄ",
      type: SubstituteTypeExt.parse("Betreuung"),
      room: "H001",
    ),
    Substitute(
      date: DateTime.parse("2020-10-19"),
      className: "5a",
      lesson: 5,
      subject: "M",
      substituteTeacher: "EIC",
      teacher: "KRÄ",
      type: SubstituteTypeExt.parse("Raum-Vtr."),
      room: "H001",
      text: "Arbeit wird geschrieben",
      substituteOf: "27.8.",
    ),
    Substitute(
      date: DateTime.parse("2020-10-19"),
      className: "5a",
      lesson: 6,
      subject: "M",
      substituteTeacher: "EIC",
      teacher: "KRÄ",
      type: SubstituteTypeExt.parse("Raum-Vtr."),
      room: "H001",
      text: "Arbeit wird geschrieben",
      substituteOf: "27.8.",
    ),
  ]);
}
