import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:memories/helpers/ui_helpers.dart';
import 'package:memories/models/model.dart';
import 'package:memories/routes.dart';
import 'package:memories/screens/camera.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TipsPage extends StatelessWidget {
  final Promotion event;
  TipsPage({this.event});
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var appBarHeight = 100.0;

    double _textFontSize = 18.0;
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: double.infinity,
        child: SafeArea(
          child: Stack(
            alignment: AlignmentDirectional.topStart,
            fit: StackFit.loose,
            children: <Widget>[
              Positioned(top: 5.0, left: 5.0, child: Logo()),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: screenHeight - 2 * appBarHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: (screenWidth - 20) / 4,
                                height: (screenWidth - 20) / 4,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).buttonColor),
                                child: Center(
                                  // child: Image.asset(
                                  //   'assets/video_camera.png',
                                  //   color: Colors.white,
                                  //   height: (screenWidth - 20) / 6,
                                  //   width: (screenWidth - 20) / 6,
                                  // ),
                                  child: Icon(
                                    FontAwesomeIcons.video,
                                    size: (screenWidth - 20) / 8,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text(
                                  "Make video \ngreetings up      \nto 7 seconds",
                                  style: TextStyle(
                                      fontSize: _textFontSize,
                                      color: Theme.of(context)
                                          .textTheme
                                          .display1
                                          .color,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: (screenWidth - 20) / 4,
                                height: (screenWidth - 20) / 4,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).buttonColor),
                                child: Center(
                                  child: Icon(
                                    FontAwesomeIcons.cameraRetro,
                                    size: (screenWidth - 20) / 8,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text(
                                "Capture those\nmagic moments\nright here",
                                style: TextStyle(
                                    fontSize: _textFontSize,
                                    color: Theme.of(context)
                                        .textTheme
                                        .display1
                                        .color,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20.0),
                    child: RaisedButton(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 60.0, right: 60.0, top: 10.0, bottom: 10.0),
                        child: Text(
                          "I'm ready",
                        ),
                      ),
                      onPressed: () {
                        startForEvent(context, event);
                      },
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  static void startForEvent(BuildContext context, Promotion event) async {
    // Fetch the available cameras before initializing the app.
    SimplePermissions.checkPermission(Permission.Camera)
        .then((permission) async {
      if (!permission) {
        SimplePermissions.requestPermission(Permission.Camera)
            .then((permission) async {
          if (permission == PermissionStatus.authorized) {
            try {
              List<CameraDescription> cameras = await availableCameras();
              cameras.forEach(
                  (camera) => camerasMap[camera.lensDirection] = camera);
              Navigator.push(
                  context,
                  SlideTransitionPageRouteBuilder((BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) =>
                      CameraScreen(
                        event: event,
                      )));
            } on CameraException catch (e) {
              logError(e.code, e.description);
            }
          }
        });
      } else {
        try {
          List<CameraDescription> cameras = await availableCameras();
          cameras
              .forEach((camera) => camerasMap[camera.lensDirection] = camera);
          Navigator.push(
              context,
              SlideTransitionPageRouteBuilder((BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) =>
                  CameraScreen(
                    event: event,
                  )));
        } on CameraException catch (e) {
          logError(e.code, e.description);
        }
      }
    });
  }
}

//onPressed: () => CameraScreen.startForEvent(context, event),
