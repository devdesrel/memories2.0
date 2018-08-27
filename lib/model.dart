import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:location/location.dart';

enum LocationStatus { pending, querying_location, location_failed, querying_events, events_failed, done }

class MemoriesModel extends Model {

  var _locationStatus = LocationStatus.pending;

  LocationStatus get locationStatus => _locationStatus;

  set locationStatus(LocationStatus locationStatus) {
    _locationStatus = locationStatus;
    notifyListeners();
  }


  Map<String, double> _currentLocation;

  set currentLocation(Map<String, double> currentLocation) {
    print("Got location!: $currentLocation");
    _currentLocation = currentLocation;
    notifyListeners();
  }

  Map<String, double> get currentLocation => _currentLocation;

  void refreshLocationAndEvents() async {
    print("Querying location...");
    locationStatus = LocationStatus.querying_location;
    try {
      currentLocation = await Location().getLocation();
      locationStatus = LocationStatus.querying_events;
    } on PlatformException catch(e) {
      print("Error querying location: $e");
      currentLocation = null;
      locationStatus = LocationStatus.location_failed;
    }
  }

}
