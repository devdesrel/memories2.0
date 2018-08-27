import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:memories/model.dart';

class StartScreen extends StatelessWidget {

  Widget initWidget(BuildContext context, Widget child, MemoriesModel model) {

    scheduleMicrotask(() {
      if (Status.events_success == model.status) {
        Navigator.pushReplacementNamed(context, '/event');
        model.status = Status.event_select;
      }
    });

    return Scaffold(
      body:
      Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: EdgeInsets.only(top: 50.0),
              child: Image.asset('assets/camera.png', width: 250.0,),
            ),

            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text('Memories Brand', style: TextStyle(fontSize: 32.0), textAlign: TextAlign.center),
            ),

            Container(
              padding: EdgeInsets.only(top: 80.0),
              child: Image.asset('assets/placeholder.png', width: 120.0,),
            ),

            Container(
              padding: EdgeInsets.only(top: 20.0, bottom: 50.0, left: 20.0, right: 20.0),
              child: Text(locationStatusText(model.status), style: TextStyle(fontSize: 24.0), textAlign: TextAlign.center,),
            ),

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MemoriesModel>(
      builder: (context, child, model) =>  initWidget(context, child, model),
    );

  }


  String locationStatusText(Status locationStatus) {
    switch(locationStatus) {
      case Status.location_pending:
        return 'Loading.';
      case Status.location_failed:
        return 'Unable to get location. Please check your settings.';
      case Status.events_query:
        return 'Looking for nearby events...';
      case Status.events_failed:
        return 'Error finding events. Please try again later.';
      case Status.events_success:
        return 'Success!';
      case Status.location_query:
        return 'Querying location...';
      default:
      return '';
    }
  }

}
