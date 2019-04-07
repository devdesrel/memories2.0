import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:memories/helpers/carousel.dart';
import 'package:memories/models/model.dart';
import 'package:memories/routes.dart';
import 'package:memories/screens/camera.dart';
import 'package:simple_permissions/simple_permissions.dart';

class TipsPage extends StatelessWidget {
  final Promotion event;
  TipsPage({this.event});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FeaturePreviewCarousel(
        dotColor: Colors.blueAccent,
        isDotIndicatorBottom: true,
        dotSize: 10.0,
        autoplay: false,
        images: <Widget>[
          TipsCarouselItem(
            message1: "Capture Those Magic Moments Right Here",
            message2:
                'Photos are auto added to the event Gallery after 5 minutes',
            message3:
                "(You can deselect any pictures you don\'t want to be shared)",
            icon: Icons.camera_alt,
            iconSize: 120.0,
            event: event,
          ),
          TipsCarouselItem(
            message1: "Make Video Greetings Up to 7 Seconds",
            message2:
                'All the videos  at the event will be assembled in order for playback',
            message3:
                "(You can deselect any videos you don\'t want to be shared)",
            icon: Icons.videocam,
            iconSize: 120.0,
            event: event,
          ),
        ],
      ),
    );
  }
}

class TipsCarouselItem extends StatelessWidget {
  final String message1;
  final String message2;
  final String message3;
  final icon;
  final double iconSize;
  final event;

  const TipsCarouselItem({
    Key key,
    @required this.message1,
    @required this.message2,
    @required this.message3,
    @required this.icon,
    @required this.iconSize,
    @required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding:
            EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  'Welcome, Duderino!',
                  style: TextStyle(fontSize: 32.0),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Here\'s the couple quick tips:',
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    icon,
                    size: iconSize,
                  ),
                ),
                Text(
                  message1,
                  style: TextStyle(fontSize: 32.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  message2,
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  message3,
                  style: TextStyle(fontSize: 12.0),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            RaisedButton(
                shape: StadiumBorder(),
                // onPressed: () async {
                //   // Navigator.push(
                //   //     context,
                //   //     SlideTransitionPageRouteBuilder((BuildContext context,
                //   //             Animation<double> animation,
                //   //             Animation<double> secondaryAnimation) =>
                //   //         CameraScreen(
                //   //           event: event,
                //   //         )));
                //   // startForEvent(context, event);
                //   Navigator.push(
                //       context,
                //       SlideTransitionPageRouteBuilder((BuildContext context,
                //               Animation<double> animation,
                //               Animation<double> secondaryAnimation) =>
                //           CameraScreen(
                //             event: event,
                //           )));
                // },
                onPressed: () => CameraScreen.startForEvent(context, event),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 50.0, right: 50.0, top: 10.0, bottom: 10.0),
                  child: Text("I\'m ready".toUpperCase(),
                      style: TextStyle(fontSize: 28.0),
                      textAlign: TextAlign.center),
                )),
          ],
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
  // bool camerPermission =
  //     await SimplePermissions.checkPermission(Permission.Camera);
  // bool recordPermission =
  //     await SimplePermissions.checkPermission(Permission.RecordAudio);
  // if (!camerPermission || !recordPermission) {
  //   try {
  //     List<CameraDescription> cameras = await availableCameras();
  //     cameras.forEach((camera) => camerasMap[camera.lensDirection] = camera);
  //     Navigator.push(
  //         context,
  //         SlideTransitionPageRouteBuilder((BuildContext context,
  //                 Animation<double> animation,
  //                 Animation<double> secondaryAnimation) =>
  //             CameraScreen(
  //               event: event,
  //             )));
  //   } on CameraException catch (e) {
  //     logError(e.code, e.description);
  //   }
  // } else {
  //   SimplePermissions.getPermissionStatus(Permission.Camera)
  //       .then((cameraStatus) {
  //     if (cameraStatus == PermissionStatus.authorized) {
  //       SimplePermissions.getPermissionStatus(Permission.RecordAudio)
  //           .then((recordStatus) {
  //         if (recordStatus == PermissionStatus.authorized) {
  //           print("done");
  //           //     try {
  //   List<CameraDescription> cameras = await availableCameras();
  //   cameras.forEach((camera) => camerasMap[camera.lensDirection] = camera);
  //   Navigator.push(
  //       context,
  //       SlideTransitionPageRouteBuilder((BuildContext context,
  //               Animation<double> animation,
  //               Animation<double> secondaryAnimation) =>
  //           CameraScreen(
  //             event: event,
  //           )));
  // } on CameraException catch (e) {
  //   logError(e.code, e.description);
  // }
  //       }
  //     });
  //   }
  // });
  // }
}
