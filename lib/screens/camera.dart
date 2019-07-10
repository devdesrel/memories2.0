import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:memories/models/model.dart';
import 'package:memories/routes.dart';
import 'package:memories/screens/photo_view.dart';
import 'package:memories/screens/upload_files_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:video_player/video_player.dart';
// import 'package:image_downloader/image_downloader.dart';

// import 'package:image_picker_saver/image_picker_saver.dart';

// Map<CameraLensDirection, CameraDescription> camerasMap = {};
Map<CameraLensDirection, CameraDescription> camerasMap = {};

class CameraScreen extends StatefulWidget {
  CameraScreen({Key key, @required this.event}) : super(key: key);

  final Promotion event;

  @override
  _CameraScreenState createState() {
    var state = _CameraScreenState();
    state.event = event;
    return state;
  }

  // static void startForEvent(BuildContext context, Event event) async {
  //   // Fetch the available cameras before initializing the app.
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
  // }
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

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _CameraScreenState extends State<CameraScreen>
    with TickerProviderStateMixin {
  Promotion event;
  CameraController controller;
  CameraDescription currentCamera;
  String imagePath;
  String videoPath;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;
  bool videoMode = false;
  AnimationController animationController;

  static const int videoLengthSecs = 7;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // startForEvent(context, event);
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: videoLengthSecs),
    );
    if (camerasMap.containsKey(CameraLensDirection.back)) {
      onNewCameraSelected(camerasMap[CameraLensDirection.back]);
    } else if (camerasMap.containsKey(CameraLensDirection.front)) {
      onNewCameraSelected(camerasMap[CameraLensDirection.front]);
    }
  }

  // static void startForEvent(BuildContext context, Event event) async {
  //   // Fetch the available cameras before initializing the app.
  //   SimplePermissions.checkPermission(Permission.Camera)
  //       .then((permission) async {
  //     if (!permission) {
  //       SimplePermissions.requestPermission(Permission.Camera)
  //           .then((permission) async {
  //         if (permission == PermissionStatus.authorized) {
  //           try {
  //             List<CameraDescription> cameras = await availableCameras();
  //             cameras.forEach(
  //                 (camera) => camerasMap[camera.lensDirection] = camera);
  //             // Navigator.push(
  //             //     context,
  //             //     SlideTransitionPageRouteBuilder((BuildContext context,
  //             //             Animation<double> animation,
  //             //             Animation<double> secondaryAnimation) =>
  //             //         CameraScreen(
  //             //           event: event,
  //             //         )));
  //           } on CameraException catch (e) {
  //             logError(e.code, e.description);
  //           }
  //         }
  //       });
  //     } else {
  //       try {
  //         List<CameraDescription> cameras = await availableCameras();
  //         cameras
  //             .forEach((camera) => camerasMap[camera.lensDirection] = camera);
  //         // Navigator.push(
  //         //     context,
  //         //     SlideTransitionPageRouteBuilder((BuildContext context,
  //         //             Animation<double> animation,
  //         //             Animation<double> secondaryAnimation) =>
  //         //         CameraScreen(
  //         //           event: event,
  //         //         )));
  //       } on CameraException catch (e) {
  //         logError(e.code, e.description);
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // var bloc = CameraBloc();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          _cameraDirectionIconButton(),
          Icon(
            Icons.flash_on,
            size: 30.0,
          ),
        ],
        title: Text(
          event.name ?? "no event",
          style: TextStyle(fontSize: 16.0),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Stack(
                children: <Widget>[
                  _cameraPreviewWidget(),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // IconButton(
                        //   // TODO: open saved photos
                        //   onPressed: () {
                        //     // getApplicationDocumentsDirectory();

                        //     ImagePickerSaver.pickImage(
                        //         source: ImageSource.gallery);

                        //     // if(file!=null && mounted)
                        //   },

                        //   icon: Icon(Icons.cloud_download),
                        //   color: Colors.white,
                        // ),
                        IconButton(
                          icon: Icon(Icons.photo_library),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.push(
                                context,
                                SlideTransitionPageRouteBuilder((BuildContext
                                            context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation) =>
                                    //TODO:
                                    // GalleryExample()
                                    UploadFilesPage(
                                      // bloc: bloc,
                                      event: event,
                                      // filesList: bloc.filesList,
                                    )));
                          },
                        ),
                        Expanded(
                          child: Text(''),
                        ),
                        // _cameraDirectionIconButton(),
                        //TODO _flashIconButton(),
                      ],
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: const Alignment(0.0, -1.0),
                        end: const Alignment(0.0, 0.6),
                        colors: <Color>[
                          const Color(0xff000000),
                          const Color(0x00000000)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
          ),
          Container(
            child: Padding(
                padding: new EdgeInsets.all(8.0),
                child: Stack(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _thumbnailWidget(),
                        _cameraVideoToggleButton(),
                      ],
                    ),
                    Center(
                      child: _cameraPrimaryActionButton(),
                    )
                  ],
                )),
            // _captureControlRowWidget(),
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

//   Widget _cameraTopActions() {
//     return Container(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           _downloadIconButton(),
//           _galleryIconButton(),
//           Expanded(
//             child: Text(''),
//           ),
//           _cameraDirectionIconButton(),
// //         TODO _flashIconButton(),
//         ],
//       ),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: const Alignment(0.0, -1.0),
//           end: const Alignment(0.0, 0.6),
//           colors: <Color>[const Color(0xff000000), const Color(0x00000000)],
//         ),
//       ),
//     );
//   }

  Widget _cameraDirectionIconButton() {
    if (currentCamera.lensDirection == CameraLensDirection.front &&
        camerasMap.containsKey(CameraLensDirection.back)) {
      return IconButton(
        onPressed: () =>
            onNewCameraSelected(camerasMap[CameraLensDirection.back]),
        icon: Icon(Icons.camera_rear),
        color: Colors.white,
      );
    } else if (currentCamera.lensDirection == CameraLensDirection.back &&
        camerasMap.containsKey(CameraLensDirection.front)) {
      return IconButton(
        onPressed: () =>
            onNewCameraSelected(camerasMap[CameraLensDirection.front]),
        icon: Icon(Icons.camera_front),
        color: Colors.white,
      );
    }
    return null;
  }

  // Widget _downloadIconButton() {
  //   return IconButton(
  //     //TODO: open saved photos
  //     onPressed: () {
  //       // getApplicationDocumentsDirectory();
  //       ImagePicker.pickImage(source: ImageSource.gallery);
  //     },
  //     icon: Icon(Icons.cloud_download),
  //     color: Colors.white,
  //   );
  // }

  // Widget _galleryIconButton() {
  //   return IconButton(
  //     icon: Icon(Icons.photo_library),
  //     color: Colors.white,
  //     onPressed: () {},
  //   );
  // }

//  Widget _flashIconButton() {
//    return IconButton(
//      onPressed: () => {},
//      icon: Icon(Icons.flash_off),
//      color: Colors.white,
//    );
//  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Initializing...',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.0,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  }

  /// Display the control bar with buttons to take pictures and record videos.
  // Widget _captureControlRowWidget() {
  //   return Padding(
  //       padding: new EdgeInsets.all(8.0),
  //       child: Stack(
  //         children: <Widget>[
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: <Widget>[
  //               _thumbnailWidget(),
  //               _cameraVideoToggleButton(),
  //             ],
  //           ),
  //           Center(
  //             child: _cameraPrimaryActionButton(),
  //           )
  //         ],
  //       ));
  // }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    return new Align(
      alignment: Alignment.centerRight,
      child: videoController == null && imagePath == null
          ? null
          : SizedBox(
              child: (videoController == null)
                  ? InkWell(
                      child: Image.file(File(imagePath)),
                      onTap: () {
                        Navigator.push(
                            context,
                            SlideTransitionPageRouteBuilder(
                                (BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation) =>
                                    UploadFilesPage(
                                      // bloc: bloc,
                                      event: event,
                                      // filesList: bloc.filesList,
                                    )));
                      },
                    )
                  : Container(
                      child: Center(
                        child: AspectRatio(
                            aspectRatio: videoController.value.size != null
                                ? videoController.value.aspectRatio
                                : 1.0,
                            child: VideoPlayer(videoController)),
                      ),
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.pink)),
                    ),
              width: 64.0,
              height: 64.0,
            ),
    );
  }

  Widget _cameraPrimaryActionButton() {
    if (videoMode) {
      if (controller != null && controller.value.isRecordingVideo) {
        return FloatingActionButton(
          child: Countdown(
            animation: StepTween(
              begin: videoLengthSecs + 1,
              end: 0,
            ).animate(animationController),
          ),
          backgroundColor: Colors.red,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  controller.value.isRecordingVideo
              ? onStopButtonPressed
              : null,
        );
      } else {
        return FloatingActionButton(
            child: Icon(
              Icons.videocam,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            onPressed: controller != null &&
                    controller.value.isInitialized &&
                    !controller.value.isRecordingVideo
                ? onVideoRecordButtonPressed
                : null);
      }
    } else {
      return FloatingActionButton(
          child: Icon(Icons.camera_alt, color: Colors.black),
          backgroundColor: Colors.white,
          onPressed: () {
            controller != null &&
                    controller.value.isInitialized &&
                    !controller.value.isRecordingVideo
                ? onTakePictureButtonPressed()
                : null;
          });
    }
  }

  Widget _cameraVideoToggleButton() {
    if (videoMode) {
      return IconButton(
        icon: Icon(Icons.camera_alt, color: Colors.white),
        onPressed: onCameraVideoTogglePressed,
      );
    } else {
      return IconButton(
        icon: Icon(Icons.videocam, color: Colors.white),
        onPressed: onCameraVideoTogglePressed,
      );
    }
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void onCameraVideoTogglePressed() {
    setState(() {
      videoMode = !videoMode;
    });
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {
        currentCamera = cameraDescription;
      });
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      //TODO: save photo on phone
      // savePhoto(filePath);
      if (mounted) {
        // bloc.filesList.add((File(filePath)));
        // print(bloc.filesList);
        // bloc.addPicture.add(File(filePath));
        // print(bloc.filesList);

        setState(() {
          imagePath = filePath;

          videoController?.dispose();
          videoController = null;
        });
      }
    });
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((String filePath) {
      //TODO: save video on phone
      // saveVideo(filePath);
      if (mounted) setState(() {});
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((_) {
      if (mounted) setState(() {});
    });
  }

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Videos/flutter_test';
    var exists = Directory(dirPath).existsSync();
    if (!exists) {
      await Directory(dirPath).create(recursive: true);
    }
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      videoPath = filePath;
      await controller.startVideoRecording(filePath);
      animationController.forward(from: 0.0);
      Timer(Duration(seconds: videoLengthSecs), stopVideoRecording);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording();
      animationController.reset();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    await _startVideoPlayer();
  }

  Future<void> _startVideoPlayer() async {
    final VideoPlayerController vcontroller =
        VideoPlayerController.file(File(videoPath));
    videoPlayerListener = () {
      if (videoController != null && videoController.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        videoController.removeListener(videoPlayerListener);
      }
    };
    vcontroller.addListener(videoPlayerListener);
    await vcontroller.setVolume(0.0);
    await vcontroller.setLooping(true);
    await vcontroller.initialize();
    await videoController?.dispose();
    if (mounted) {
      setState(() {
        imagePath = null;
        videoController = vcontroller;
      });
    }
    await vcontroller.play();
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    var exists = Directory(dirPath).existsSync();
    if (!exists) {
      await Directory(dirPath).create(recursive: true);
    }
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
      // var image = ImagePickerSaver.pickImage(source: ImageSource.camera);
      // ImagePickerSaver.saveFile(fileData:(Uri.file(filePath).) );

      // var path = await getApplicationDocumentsDirectory();
      // print(path);

      // ImagePickerSaver.saveFile(fileData:File.fromUri(Uri.file(filePath).bodyBytes));
      // ImageDownloader.downloadImage(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    return new Text(
      animation.value.toString(),
      style: new TextStyle(
          fontSize: 24.0, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }
}
