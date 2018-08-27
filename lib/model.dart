import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

enum Status { location_pending, location_query, location_failed, events_query, events_failed, events_success, event_select }

class Event {
  final String id;
  final String name;

  Event({this.id, this.name});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name']
    );
  }

  static List<Event> listFromJson(Map<String, dynamic> json) {
    List<Event> eventsList = [];
    (json['events'] as List).forEach((model) => eventsList.add(Event.fromJson(model as Map<String, dynamic>)));
    return eventsList;
  }


}

class MemoriesModel extends Model {

  static const eventsUrl = "https://raw.githubusercontent.com/wongcain/memories-flutter/master/json/events.json";

  var _status = Status.location_pending;

  Status get status => _status;

  set status(Status locationStatus) {
    _status = locationStatus;
    notifyListeners();
  }


  Map<String, double> _currentLocation;

  set currentLocation(Map<String, double> currentLocation) {
    print("Got location!: $currentLocation");
    _currentLocation = currentLocation;
    notifyListeners();
  }

  Map<String, double> get currentLocation => _currentLocation;

  List<Event> _events;

  List<Event> get events => _events;

  set events(List<Event> events) {
    _events = events;
    notifyListeners();
  }

  void refreshLocationAndEvents() async {
    print("Querying location...");
    status = Status.location_query;
    try {
      currentLocation = await Location().getLocation();
      status = Status.events_query;

      var client = new http.Client();
      client.get(eventsUrl).then((response) => handleEventsResponse(response));

    } on PlatformException catch(e) {
      print("Error querying location: $e");
      currentLocation = null;
      status = Status.location_failed;
    }
  }

  void handleEventsResponse(http.Response response) {
    if (response.statusCode == 200) {
      print("statusCode: ${response.statusCode}\nbody: ${response.body}");
      events = Event.listFromJson(json.decode(response.body));
      status = Status.events_success;
      print("Events: $events");
    } else {
      print("Error fetching events: ${response.statusCode} - ${response.body}");
      status = Status.events_failed;
    }
  }

}
