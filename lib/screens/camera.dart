import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:memories/routes.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:memories/model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

Map<CameraLensDirection, CameraDescription> camerasMap = {};

void startCamera(BuildContext context) async {
  // Fetch the available cameras before initializing the app.
  try {
    List<CameraDescription> cameras = await availableCameras();
    cameras.forEach((camera) => camerasMap[camera.lensDirection] = camera);
    Navigator.push(context, Routes.cameraScreen);
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
}

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() {
    return new _CameraScreenState();
  }
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _CameraScreenState extends State<CameraScreen> {
  CameraController controller;
  CameraDescription currentCamera;
  String imagePath;
  String videoPath;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if(camerasMap.containsKey(CameraLensDirection.back)) {
      onNewCameraSelected(camerasMap[CameraLensDirection.back]);
    } else if(camerasMap.containsKey(CameraLensDirection.front)) {
      onNewCameraSelected(camerasMap[CameraLensDirection.front]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MemoriesModel>(
        builder: (context, child, model) =>  Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.keyboard_arrow_left),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(model.currentEvent.name),
            backgroundColor: Colors.black,
          ),
          body: new Column(
            children: <Widget>[
              new Expanded(
                child: new Container(
                  child: Stack(
                    children: <Widget>[
                      _cameraPreviewWidget(),
                      _cameraTopActions(),
                    ],
                  ),
                  decoration: new BoxDecoration(
                    color: Colors.black,
                  ),
                ),
              ),
              _captureControlRowWidget(),
            ],
          ),
        )
    );
  }

  Widget _cameraTopActions() {
    return Container(
      child: Row(
        children: <Widget>[
          _galleryIconButton(),
          Expanded(
            child: Text(''),
          ),
          _cameraDirectionIconButton(),
          _flashIconButton(),
        ],
      ),
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          begin: const Alignment(0.0, -1.0),
          end: const Alignment(0.0, 0.6),
          colors: <Color>[
            const Color(0xff000000),
            const Color(0x00000000)
          ],
        ),
      ),
    );
  }

  Widget _cameraDirectionIconButton() {
    if(currentCamera.lensDirection == CameraLensDirection.front && camerasMap.containsKey(CameraLensDirection.back)) {
      return IconButton(
        onPressed: () => onNewCameraSelected(camerasMap[CameraLensDirection.back]),
        icon: new Icon(Icons.switch_camera),
        color: Colors.white,
      );
    } else if (currentCamera.lensDirection == CameraLensDirection.back && camerasMap.containsKey(CameraLensDirection.front)){
      return IconButton(
        onPressed: () => onNewCameraSelected(camerasMap[CameraLensDirection.front]),
        icon: new Icon(Icons.switch_camera),
        color: Colors.white,
      );
    }
    return null;
  }

  Widget _galleryIconButton() {
    return IconButton(
      onPressed: () => {},
      icon: new Icon(Icons.photo_library),
      color: Colors.white,
    );
  }

  Widget _flashIconButton() {
    return IconButton(
      onPressed: () => {},
      icon: new Icon(Icons.flash_off),
      color: Colors.white,
    );
  }

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
      return new AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: new CameraPreview(controller),
      );
    }
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    return new Expanded(
      child: new Align(
        alignment: Alignment.centerRight,
        child: videoController == null && imagePath == null
            ? null
            : new SizedBox(
                child: (videoController == null)
                    ? new Image.file(new File(imagePath))
                    : new Container(
                        child: new Center(
                          child: new AspectRatio(
                              aspectRatio: videoController.value.size != null
                                  ? videoController.value.aspectRatio
                                  : 1.0,
                              child: new VideoPlayer(videoController)),
                        ),
                        decoration: new BoxDecoration(
                            border: new Border.all(color: Colors.pink)),
                      ),
                width: 64.0,
                height: 64.0,
              ),
      ),
    );
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.blue,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  !controller.value.isRecordingVideo
              ? onTakePictureButtonPressed
              : null,
        ),
        new IconButton(
          icon: const Icon(Icons.videocam),
          color: Colors.blue,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  !controller.value.isRecordingVideo
              ? onVideoRecordButtonPressed
              : null,
        ),
        new IconButton(
          icon: const Icon(Icons.stop),
          color: Colors.red,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  controller.value.isRecordingVideo
              ? onStopButtonPressed
              : null,
        )
      ],
    );
  }

  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = new CameraController(cameraDescription, ResolutionPreset.high);

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
      if (mounted) {
        setState(() {
          imagePath = filePath;
          videoController?.dispose();
          videoController = null;
        });
        if (filePath != null) showInSnackBar('Picture saved to $filePath');
      }
    });
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((String filePath) {
      if (mounted) setState(() {});
      if (filePath != null) showInSnackBar('Saving video to $filePath');
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recorded to: $videoPath');
    });
  }

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await new Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      videoPath = filePath;
      await controller.startVideoRecording(filePath);
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
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    await _startVideoPlayer();
  }

  Future<void> _startVideoPlayer() async {
    final VideoPlayerController vcontroller =
        new VideoPlayerController.file(new File(videoPath));
    videoPlayerListener = () {
      if (videoController != null && videoController.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        videoController.removeListener(videoPlayerListener);
      }
    };
    vcontroller.addListener(videoPlayerListener);
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
    await new Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
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
