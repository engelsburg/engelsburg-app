class Events {
  Events({
    this.events = const [],
  });

  final List<Event> events;

  factory Events.fromJson(Map<String, dynamic> json) => Events(
        events: json['events'] == null
            ? []
            : List<Event>.from(json['events'].map((x) => Event.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'events': List<dynamic>.from(events.map((x) => x.toJson())),
      };
}

class Event {
  Event({
    this.date,
    this.title,
  });

  final DateTime? date;
  final String? title;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        date: DateTime.tryParse(json['date']),
        title: json['title'],
      );

  Map<String, dynamic> toJson() => {
        'date': date?.toIso8601String(),
        'title': title,
      };
}
