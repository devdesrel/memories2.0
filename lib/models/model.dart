// const eventsUrl =
//     // "https://raw.githubusercontent.com/wongcain/memories-flutter/master/json/events.json";
//     "https://raw.githubusercontent.com/devdesrel/memories/master/event.json";

class Event {
  final bool success;
  final String message;
  final String error;
  final List<Promotion> promotion;

  Event({this.success, this.message, this.error, this.promotion});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      message: json['msg'] ?? '',
      error: json['error'] ?? '',
      promotion: json['promotions']
              .map<Promotion>((item) => Promotion.fromJson(item))
              .toList() ??
          <Promotion>[],
      success: json['success'] ?? false,
    );
  }

  // static List<Event> listFromJson(Map<String, dynamic> json) {
  //   List<Event> eventsList = [];
  //   (json['events'] as List).forEach((model) =>
  //       eventsList.add(Event.fromJson(model as Map<String, dynamic>)));
  //   return eventsList;
  // }
}

class Promotion {
  final int campaignid;
  final String iframeKey;
  final double latitude;
  final double longtitude;
  final double radius;
  final String name;

  Promotion(
      {this.campaignid,
      this.iframeKey,
      this.latitude,
      this.longtitude,
      this.radius,
      this.name});
  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
        campaignid: json['campaignid'],
        iframeKey: json['iframeKey'],
        latitude: json['location_latitude'],
        longtitude: json['location_longitude'],
        radius: json['location_radius'],
        name: json['name']);
  }
}
