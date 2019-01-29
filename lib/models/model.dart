const eventsUrl =
    // "https://raw.githubusercontent.com/wongcain/memories-flutter/master/json/events.json";
    "https://raw.githubusercontent.com/devdesrel/memories/master/event.json";

class Event {
  final String id;
  final String name;

  Event({this.id, this.name});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(id: json['id'], name: json['name']);
  }

  static List<Event> listFromJson(Map<String, dynamic> json) {
    List<Event> eventsList = [];
    (json['events'] as List).forEach((model) =>
        eventsList.add(Event.fromJson(model as Map<String, dynamic>)));
    return eventsList;
  }
}
