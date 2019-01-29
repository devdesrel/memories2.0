import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class CameraBloc {
  List<File> filesList = [];
  List<String> photosDirecsList = [];
  List<String> videosDirecsList = [];
  List<String> fileList = [];
  // List<String> photosList=[];
  List<int> selectedImagesList = [];
  String photosDirectory = "/Pictures/flutter_test";
  // String videosDirectory = "/Movies/flutter_test";
  List<FileSystemEntity> _allPathsList;
  static const platform =
      const MethodChannel('com.bakhronova.flutter.fileopener');

  List<String> _directoriesList = List();
  List<String> _filesList = List();

  List<String> _filteredPathsList = List();

  Future<Directory> getDirectory() async {
    var directory = await getApplicationDocumentsDirectory();
    return directory;
  }

  Future<List<String>> getPhotosList(String mainDirectory) async {
    _allPathsList = [];
    _filteredPathsList = [];
    _directoriesList = [];
    _filesList = [];
    Directory dir;
    Directory directory;
    await getDirectory().then((direc) {
      directory = direc;
    });

    if (directory.path != null) {
      dir = Directory('${directory.path}$mainDirectory');

      var isExists = dir.existsSync();
      if (!isExists) {
        dir.createSync(recursive: true);
      }
      _allPathsList = dir.listSync(recursive: false, followLinks: true);

      for (int i = 0; i < _allPathsList.length; i++) {
        var path = _allPathsList.elementAt(i).path;
        var filename = basename(path);

        var isDirectory = FileSystemEntity.isDirectorySync(path);
        var isFile = FileSystemEntity.isFileSync(path);

        if (!filename.startsWith('.')) {
          if (isDirectory)
            _directoriesList.add(path);
          else if (isFile) {
            _filesList.add(path);
          }
        }
      }
      // _directoriesList.sort();
      // _filesList.sort();
      // _directoriesList = _directoriesList.reversed.toList();
      // _filesList = _filesList.reversed.toList();

      _filteredPathsList = _directoriesList + _filesList;
    } else {
      print('path unavailable');
    }

    if (_allPathsList != null && _allPathsList.length > 0) {
      print(_filteredPathsList);
      return _filteredPathsList;
    } else if (_allPathsList != null && _allPathsList.length == 0) {
      return null;
    }

    return null;
  }

  addPhotosListToStream() async {
    // await getPhotosList(photosDirectory).then((photosList) {
    //   photosDirecsList = photosList;
    //   _photosListSubject.add(photosDirecsList);
    // });
    fileList = await getPhotosList(photosDirectory);
    // List<String> videos = await getPhotosList(videosDirectory);
    // fileList = photos + videos;
    fileList = fileList.reversed.toList();

    _photosListSubject.add(fileList);
  }

  ///[Siink]
  Sink<File> get addPicture => _addPictureController.sink;

  final _addPictureController = StreamController<File>();

  Sink<File> get deletePicture => _deletePictureController.sink;

  final _deletePictureController = StreamController<File>();

  Sink<bool> get setGridView => _setGridViewController.sink;

  final _setGridViewController = StreamController<bool>();

  Sink<int> get addPhotoIndexToSelected =>
      _addPhotoIndexToSelectedController.sink;

  final _addPhotoIndexToSelectedController = StreamController<int>();
  Sink<int> get removePhotoIndexFromSelected =>
      _removePhotoIndexFromSelectedController.sink;

  final _removePhotoIndexFromSelectedController = StreamController<int>();
  Sink<String> get removePhotoFromList => _removePhotoFromListController.sink;

  final _removePhotoFromListController = StreamController<String>();

  ///[Stream]
  // Stream<File> get getPictures => _getPicturesSubject.stream;

  // final _getPicturesSubject = BehaviorSubject<File>();

  Stream<List<String>> get photosList => _photosListSubject.stream;

  final _photosListSubject = BehaviorSubject<List<String>>();

  Stream<bool> get isGridView => _isGridViewSubject.stream;

  final _isGridViewSubject = BehaviorSubject<bool>(seedValue: true);

  Stream<List<int>> get selectedPhotosList => _selectedPhotosListSubject.stream;

  final _selectedPhotosListSubject = BehaviorSubject<List<int>>();

  CameraBloc() {
    addPhotosListToStream();

    _addPictureController.stream.listen((picture) {
      filesList.add(picture);
      fileList = fileList.reversed.toList();

      _photosListSubject.add(fileList);
    });
    // _deletePictureController.stream.listen((picture) {
    //   filesList.remove(picture);
    // });
    _setGridViewController.stream.listen((val) {
      _isGridViewSubject.add(val);
    });

    _addPhotoIndexToSelectedController.stream.listen((index) {
      selectedImagesList.add(index);
      _selectedPhotosListSubject.add(selectedImagesList);
    });

    _removePhotoIndexFromSelectedController.stream.listen((index) {
      selectedImagesList.remove(index);
      _selectedPhotosListSubject.add(selectedImagesList);
    });
    _removePhotoFromListController.stream.listen((image) {
      fileList.remove(image);
      _photosListSubject.add(fileList);
    });
  }

  dispose() {
    _addPictureController.close();
    _deletePictureController.close();
    _photosListSubject.close();
    _setGridViewController.close();
    _isGridViewSubject.close();
    _addPhotoIndexToSelectedController.close();
    _selectedPhotosListSubject.close();
    _removePhotoIndexFromSelectedController.close();
    _removePhotoFromListController.close();
  }
}
