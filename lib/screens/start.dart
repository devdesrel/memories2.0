import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memories/model.dart';
import 'package:scoped_model/scoped_model.dart';

class StartScreen extends StatefulWidget {
  @override
  State createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  Animation<double> logoSizeAnim;
  AnimationController logoAnimCtrl;

  bool isAnimPending() {
    return !logoAnimCtrl.isCompleted && !logoAnimCtrl.isAnimating && !logoAnimCtrl.isDismissed;
  }

  @override
  void initState() {
    print('START INIT STATE');
    super.initState();
    logoAnimCtrl = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    logoSizeAnim = Tween(begin: 200.0, end: 120.0).animate(logoAnimCtrl)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MemoriesModel>(
      builder: (context, child, model) => initWidget(context, child, model),
    );
  }

  Widget initWidget(BuildContext context, Widget child, MemoriesModel model) {
    if (Status.query_events_success == model.status) {
      if(!logoSizeAnim.isCompleted) {
        logoAnimCtrl.forward();
      } else {
        model.status = Status.event_selection;
      }
    }

    Widget bottomWidget;
    switch (model.status) {
      case Status.query_events_success:
        bottomWidget = Text("");
        break;
      case Status.event_selection:
        bottomWidget = EventSelectionWidget();
        break;
      default:
        bottomWidget = LocationStatusWidget();

    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: SvgPicture.asset(
                  'assets/friendship.svg',
                  width: logoSizeAnim.value,
                  height: logoSizeAnim.value,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Text('Memories Brand',
                    style: TextStyle(fontSize: 32.0),
                    textAlign: TextAlign.center),
              ),
            ],
          ),
          bottomWidget,
        ],
      ),
    );
  }

}


class LocationStatusWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  ScopedModelDescendant<MemoriesModel>(
        builder: (context, child, model) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 0.0),
              child: SvgPicture.asset(
                'assets/location.svg',
                width: 80.0,
                height: 80.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 20.0, bottom: 50.0, left: 20.0, right: 20.0),
              child: Text(
                locationStatusText(model.status),
                style: TextStyle(fontSize: 24.0),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
    );
  }

  String locationStatusText(Status locationStatus) {
    switch (locationStatus) {
      case Status.loading:
        return 'Loading.';
      case Status.query_location_failed:
        return 'Unable to get location. Please check your settings.';
      case Status.querying_events:
        return 'Looking for nearby events...';
      case Status.query_events_failed:
        return 'Error finding events. Please try again later.';
      case Status.query_events_success:
        return 'Success!';
      case Status.querying_location:
        return 'Querying location...';
      default:
        return '';
    }
  }
}


class EventSelectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  ScopedModelDescendant<MemoriesModel>(
      builder: (context, child, model) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text('Are you attending', style: TextStyle(fontSize: 16.0), textAlign: TextAlign.center),
          ),

          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text("${model.events[0].name}?", style: TextStyle(fontSize: 32.0), textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

}