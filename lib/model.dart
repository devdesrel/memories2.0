import 'package:scoped_model/scoped_model.dart';

enum LocationStatus { querying_location, location_failed, querying_events, events_failed, done }

class MemoriesModel extends Model {

  LocationStatus _locationStatus = LocationStatus.querying_location;

  LocationStatus get locationStatus => _locationStatus;

  set locationStatus(LocationStatus locationStatus) {
    _locationStatus = locationStatus;
    notifyListeners();
  }

}
