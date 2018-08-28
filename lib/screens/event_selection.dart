import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:memories/model.dart';

class EventSelectionScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<MemoriesModel>(
      builder: (context, child, model) =>  Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: EdgeInsets.only(top: 50.0),
                child: Image.asset('assets/camera.png', width: 200.0,),
              ),

              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Text('Memories Brand', style: TextStyle(fontSize: 24.0), textAlign: TextAlign.center),
              ),

              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Text('Are you attending', style: TextStyle(fontSize: 16.0), textAlign: TextAlign.center),
              ),

              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Text("${model.events[0].name}?", style: TextStyle(fontSize: 32.0), textAlign: TextAlign.center),
              ),

            ],
          ),
        ),
      ),
    );

  }

}
