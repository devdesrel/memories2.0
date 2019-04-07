import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:memories/constants.dart';
import 'package:memories/models/model.dart';
import 'package:rxdart/rxdart.dart';

class StartBloc {
  Future<Map<String, double>> getLocation() async {
    Map<String, double> _currentLocation;
    try {
      var location = new Location();
      await location.getLocation().then((location) {
        print(location);
        _currentLocation = {
          "latitude": location["latitude"],
          "longitude": location["longitude"],
        };
        // });
        print(_currentLocation["latitude"]);
        print(_currentLocation["longitude"]);
      });
    } catch (e) {
      //TODO: use flushbar
      print('ahh fuck');
    }
    return _currentLocation;
  }

  Future<List<Promotion>> eventsApiRequest() async {
    List<Promotion> _promotionList;
    var _location = await getLocation();
    if (_location != null) {
      try {
        Map<String, String> header = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        };
        var body = json.encode({
          "apikey": apiKey,
          "latitude": _location["latitude"].toString(),
          "longitude": _location["longitude"].toString()
        });
        Response _response =
            await http.post('$getPromotionsApi', headers: header, body: body);
        if (_response.statusCode == 200) {
          var parsed = json.decode(_response.body);
          var res = parsed["promotions"] as List;
          _promotionList =
              res.map<Promotion>((item) => Promotion.fromJson(item)).toList();
        }
      } catch (e) {
        print(e);
      }
    }
    Promotion testValue = Promotion(
        campaignid: 1,
        iframeKey: "2cda98e067ead6c88f4b560dcc2531bd",
        latitude: 34.9485,
        longtitude: 34.0034,
        radius: 34,
        name: "Test promotion");
    Promotion testValue2 = Promotion(
        campaignid: 2,
        iframeKey: "2cda98e067ead6c88f4b560dcc2531bd",
        latitude: 34.9485,
        longtitude: 34.0034,
        radius: 34,
        name: "Test promotion 2");

    _promotionList == null
        ? _promotionList = []
        : _promotionList = _promotionList;

    _promotionList.add(testValue);
    _promotionList.add(testValue2);

    return _promotionList;
  }

  Stream<List<Promotion>> get listOfPromotions =>
      _listOfPromotionsSubject.stream;

  final _listOfPromotionsSubject = BehaviorSubject<List<Promotion>>();

  Stream<bool> get retryButton => _retryButtonSubject.stream;

  final _retryButtonSubject = BehaviorSubject<bool>();

  Sink<bool> get isRetryPressed => _isRetryPressedController.sink;

  final _isRetryPressedController = StreamController<bool>();
  void getPromotions() {
    eventsApiRequest().then((promotions) {
      _listOfPromotionsSubject.add(promotions);
    });
  }

  StartBloc() {
    getPromotions();

    _isRetryPressedController.stream.listen((isPressed) {
      if (isPressed) {
        getPromotions();
        _retryButtonSubject.add(false);
      }
    });
  }
  dispose() {
    _listOfPromotionsSubject.close();
    _isRetryPressedController.close();
  }
}
