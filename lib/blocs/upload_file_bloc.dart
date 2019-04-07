import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:memories/constants.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class FileUploadBloc {
  // List<File> filesList = [];
  List<String> photosDirecsList = [];
  List<String> videosDirecsList = [];
  List<String> fileList = [];
  // List<String> photosList=[];
  List<int> selectedImagesIndexList = [];
  List<File> selectedFilesList = [];
  List<String> selectedFilesAsStringList = [];
  String photosDirectory = "/Pictures/flutter_test";
  String videosDirectory = "/Videos/flutter_test";
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
    List<String> nullFixer = [];
    videosDirecsList = await getPhotosList(videosDirectory) ?? nullFixer;
    photosDirecsList = await getPhotosList(photosDirectory) ?? nullFixer;
    fileList = videosDirecsList + photosDirecsList;
    // fileList = await getPhotosList(photosDirectory);
    // fileList = (videosDirecsList ?? [] + photosDirecsList ?? []);

    // List<String> videos = await getPhotosList(videosDirectory);
    // fileList = photos + videos;
    fileList = fileList == null ? [] : fileList.reversed.toList();

    _allFilesListSubject.add(fileList);
    _videosListSubject.add(videosDirecsList.reversed.toList());
    _photosListSubject.add(photosDirecsList.reversed.toList());
  }

// Future<UploadApiResponseModel> uploadFile(){
//   var uri = Uri.parse("http://pub.dartlang.org/packages/create");
// var request = new http.MultipartRequest("POST", uri);
// request.fields['user'] = 'nweiz@google.com';
// request.files.add(new http.MultipartFile.fromFile(
//     'package',
//     new File('build/package.tar.gz'),
//     contentType: new MediaType('application', 'x-tar'));
// request.send().then((response) {
//   if (response.statusCode == 200) print("Uploaded!");
// });
// }
// // Future<MultipartFile> testFile=  MultipartFile.fromPath('sdsf', "sdfsfds", {});

// Future<UploadApiResponseModel> test(){
//   var url=Uri.parse(uploadApi);
//   var request= http.MultipartRequest("POST", url);
//   request.fields['sd']='as';
//   request.fields['d']='';
//   request.files.add(testFile)
// }

// {
//   "apikey": "t0psycr3t3",
//   "iframeKey": "2cda98e067ead6c88f4b560dcc2531bd",
//   "fields": [
//     {
//       "key": "first_name",
//       "value": "Anvar New"
//     },
//     {
//       "key": "last_name",
//       "value": "Akramov New"
//     },
//     {
//       "key": "email_address",
//       "value": "anvar.akramov@gmail.com"
//     },
//     {
//       "key": "test",
//       "value": "test"
//     },
//     {
//       "key": "checkboxtest",
//       "value": "true"
//     },
//     {
//       "key": "promotion_items",
//       "value": "aaaaaaaaaaa"
//     }
//   ]
// }
  mainUploadFunction() {
    int filesCount = selectedFilesList.length;
    if (filesCount != 0) {
      print(selectedFilesList[0].length());
      // for (var i = 0; i < filesCount; i++) {
      upload(selectedFilesList[0]).then((isUploaded) {
        print(isUploaded);
      });
      // }
    }
  }

  Future<bool> upload(File file) async {
    bool isSuccessfull;

    try {
      Map<String, String> fields = {
        "apikey": "t0psycr3t3",
        "iframeKey": "2cda98e067ead6c88f4b560dcc2531bd",
        "first_name": "Durdona",
        "last_name": "Bakhronova",
        "email_address": "anvar.akramov@gmail.com",
        "checkboxtest": "true",
        "promotion_items": "aaaaaaaaaaa"
      };
      // open a bytestream
      var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
      // get file length
      var length = await file.length();
      print(length);
      // string to uri
      var uri = Uri.parse(uploadApi);

      // create multipart request
      var request = new http.MultipartRequest("POST", uri);
      request.fields.addAll(fields);

      // multipart that takes file
      var multipartFile = new http.MultipartFile('file', stream, length,
          filename: basename(file.path));

      // add file to multipart
      request.files.add(multipartFile);
      // send
      var response = await request.send().then((result) {
        result.statusCode == 200 ? isSuccessfull = true : isSuccessfull = false;
      });
      print(response.statusCode);

      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    } catch (e) {
      //TODO: show flushbar/snackbar
      print(e);
    }

    return isSuccessfull;
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

  Sink<int> get getBottomVanigationValue =>
      _getBottomVanigationValueController.sink;

  final _getBottomVanigationValueController = StreamController<int>();

  ///[Stream]
  // Stream<File> get getPictures => _getPicturesSubject.stream;

  // final _getPicturesSubject = BehaviorSubject<File>();

  Stream<List<String>> get allFilesList => _allFilesListSubject.stream;

  final _allFilesListSubject = BehaviorSubject<List<String>>();

  Stream<List<String>> get photosList => _photosListSubject.stream;

  final _photosListSubject = BehaviorSubject<List<String>>();

  Stream<bool> get isGridView => _isGridViewSubject.stream;

  final _isGridViewSubject = BehaviorSubject<bool>(seedValue: true);

  Stream<List<int>> get selectedPhotosList => _selectedPhotosListSubject.stream;

  final _selectedPhotosListSubject = BehaviorSubject<List<int>>();

  Stream<List<String>> get selectedFilesAsString =>
      _selectedFilesAsStringSubject.stream;

  final _selectedFilesAsStringSubject = BehaviorSubject<List<String>>();

  Stream<int> get bottomNavigationSelectedValue =>
      bottomNavigationSelectedValueSubject.stream;

  final bottomNavigationSelectedValueSubject = BehaviorSubject<int>();

  Stream<List<String>> get videosList => _videosListSubject.stream;

  final _videosListSubject = BehaviorSubject<List<String>>();

  FileUploadBloc() {
    addPhotosListToStream();

    // _addPictureController.stream.listen((picture) {
    //   filesList.add(picture);
    //   fileList = fileList.reversed.toList();

    //   _photosListSubject.add(fileList);
    // });
    // _deletePictureController.stream.listen((picture) {
    //   filesList.remove(picture);
    // });
    _setGridViewController.stream.listen((val) {
      _isGridViewSubject.add(val);
    });

    _addPhotoIndexToSelectedController.stream.listen((index) {
      selectedImagesIndexList.add(index);
      _selectedPhotosListSubject.add(selectedImagesIndexList);
      print(fileList);
      selectedFilesList.add(File(fileList[index]));
      selectedFilesAsStringList.add(fileList[index]);
      _selectedFilesAsStringSubject.add(selectedFilesAsStringList);
      print(selectedFilesList);
    });

    _removePhotoIndexFromSelectedController.stream.listen((index) {
      selectedImagesIndexList.remove(index);
      _selectedPhotosListSubject.add(selectedImagesIndexList);
      // selectedFilesList.remove(filesList[index]);
      selectedFilesList.remove(fileList[index]);
    });
    _removePhotoFromListController.stream.listen((image) {
      fileList.remove(image);
      _allFilesListSubject.add(fileList);
    });
    _getBottomVanigationValueController.stream.listen((val) {
      bottomNavigationSelectedValueSubject.add(val);
    });
  }

  dispose() {
    _addPictureController.close();
    _deletePictureController.close();
    _allFilesListSubject.close();
    _setGridViewController.close();
    _isGridViewSubject.close();
    _addPhotoIndexToSelectedController.close();
    _selectedPhotosListSubject.close();
    _removePhotoIndexFromSelectedController.close();
    _removePhotoFromListController.close();
    _selectedFilesAsStringSubject.close();
    bottomNavigationSelectedValueSubject.close();
    _getBottomVanigationValueController.close();
    _videosListSubject.close();
    _photosListSubject.close();
  }
}
