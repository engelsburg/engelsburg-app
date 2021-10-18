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
    this.type,
    this.substituteOf,
    this.room,
    this.text,
  });

  final String? date;
  final String? className;
  final String? lesson;
  final String? subject;
  final String? substituteTeacher;
  final String? teacher;
  final String? type;
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

  final String? date;
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
