import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:memories/constants.dart';
import 'package:memories/models/files_from_server.dart';
import 'package:memories/models/upload_file_details_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

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
  int navigationIndex = 0;
  int currentFileIndex = 0;

  List<String> eventPhotosFromServerList = [];
  List<String> eventViedeosFromServerList = [];

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

  Future<List<String>> getEventPhotosFromServerList() async {
    //7075a9c1526ca649a137dd9cd2483126 => for video upload
    var iframeKey = "8c1a237b2b84212be113d71e194bd393";
    var secret = "secret";
    var secretValue = "secret";
    var imageTypeValue = "UPLOADED_IMAGE";
    // var queryParameters = {
    //   '$secret': '$secretValue',
    //   'image_type': '$imageTypeValue',
    // };
    // var uri = Uri.https(apiGetFiles, '/$iframeKey', queryParameters);

    List<String> urls = [];
    try {
      var response = await http.get(
          "$apiGetFiles/$iframeKey?secret=$secretValue&image_type=$imageTypeValue");
      // var response = await http.get(uri);
      if (response.statusCode == 200) {
        var jsonBody = json.decode(response.body);
        List<Photos> result = EventFilesModel.fromJson(jsonBody).photos;
        if (result.length > 0) result.forEach((r) => urls.add(r.url));
      }
    } catch (e) {
      print(e);
    }
    return urls;
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
    if (selectedFilesList.length > 0) {
      _selectedFilesAsStringSubject.add(selectedFilesAsStringList);
      _navigationbarIndexSubject.add(1);
      navigationIndex = 1;
      int filesCount = selectedFilesList.length;
      if (filesCount != 0) {
        // print(selectedFilesList[0].length());
        for (var i = 0; i < filesCount; i++) {
          currentFileIndex = i;
          uploadD(selectedFilesList[i], i).then((isUploaded) {
            print(isUploaded);

            selectedImagesIndexList.clear();
            _selectedPhotosListSubject.add(selectedImagesIndexList);
          });
        }
      }
    }
  }

  // test() async {
  //   var dio = Dio();
  //   "https://raw.githubusercontent.com/devdesrel/memories/master/event.json";
  //   Response response = await dio.get(
  //       "https://raw.githubusercontent.com/devdesrel/memories/master/event.json");
  //   print(response.data);
  //   return true;
  // }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
      double percent = received / total;
      UploadFileDetailes details =
          UploadFileDetailes(index: currentFileIndex, downloadPercent: percent);
      _downloadDetailsSubject.add(details);
    }
  }

  Future<bool> uploadD(File file, index) async {
    bool isSuccessfull = false;
    var dio = Dio();
    dio.options.baseUrl = "$baseUrl";
    dio.interceptors.add(LogInterceptor(
        requestBody: true,
        request: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true));
    String message = "{\n" +
        "          \"iframeKey\": \"8c1a237b2b84212be113d71e194bd393\",\n" +
        "          \"apikey\": \"t0psycr3t3\",\n" +
        "          \"secret\": \"secret\",\n" +
        "          \"fields\": [\n" +
        "            {\"key\": \"first_name\", \"value\": \"videoupload\"},\n" +
        "            {\"key\": \"larst_name\", \"value\": \"videoupload\"},\n" +
        "            {\"key\": \"test\", \"value\": \"videoupload\"},\n" +
        "            {\"key\": \"checkboxtest\", \"value\": \"true\"},\n" +
        "            {\"key\": \"email_address\", \"value\": \"anvar.akramov@gmail.com\"}\n" +
        "          ]\n" +
        "        }";

    try {
      FormData formData = FormData.from({
        "body": message,
        // {
        //   "iframeKey": "8c1a237b2b84212be113d71e194bd393",
        //   "apikey": "t0psycr3t3",
        //   "secret": "secret",
        //   "fields": [
        //     {"key": "first_name", "value": "videoupload"},
        //     {"key": "larst_name", "value": "videoupload"},
        //     {"key": "test", "value": "videoupload"},
        //     {"key": "checkboxtest", "value": "true"},
        //     {"key": "email_address", "value": "anvar.akramov@gmail.com"}
        //   ]
        // },
        "photo_upload": [
          new UploadFileInfo(new File(file.path), basename(file.path)),
          new UploadFileInfo(new File(file.path), basename(file.path)),
        ],
      });

      Response response;
      response = await dio.post("/submit",
          data: formData,
          onSendProgress: showDownloadProgress,
          options: new Options(
            connectTimeout: 100000,
            receiveTimeout: 100000,
            contentType: ContentType.parse("application/x-www-form-urlencoded"),
          ));
      if (response.statusCode == 200) {
        isSuccessfull = true;
      }
    } on DioError catch (e) {
      // print(e.response.data ?? "no data");
      print(e.response.headers);
      print(e.response.request);
      print(e.request);
      print(e.message);
    }
    return isSuccessfull;
  }

//   Future<bool> uploadDio(File file) async {
//     var dio = Dio();
//     bool isSuccessfull;

//     Map<String, dynamic> body = {
//       "iframeKey": "8c1a237b2b84212be113d71e194bd393",
//       "apikey": "t0psycr3t3",
//       "secret": "secret",
//       "fields": [
//         {"key": "first_name", "value": "videoupload"},
//         {"key": "larst_name", "value": "videoupload"},
//         {"key": "test", "value": "videoupload"},
//         {"key": "checkboxtest", "value": "true"},
//         {"key": "email_address", "value": "something@gmail.com"}
//       ],
//       "file": new UploadFileInfo(file, basename(file.path)),
//     };

//     try {
//       // var response = await dio.post('$uploadApi',
//       //     data: body,
//       //     options: new Options(
//       //         contentType:
//       //             ContentType.parse("application/x-www-form-urlencoded")));

//       // if (response.statusCode == 200) {
//       //   isSuccessfull = true;
//       // }
//       // print(response);
//       FormData formData = new FormData.from({
//         "iframeKey": "8c1a237b2b84212be113d71e194bd393",
//         "apikey": "t0psycr3t3",
//         "secret": "secret",
//         "fields": [
//           {"key": "first_name", "value": "videoupload"},
//           {"key": "larst_name", "value": "videoupload"},
//           {"key": "test", "value": "videoupload"},
//           {"key": "checkboxtest", "value": "true"},
//           {"key": "email_address", "value": "something@gmail.com"}
//         ],
//         "file": new UploadFileInfo(file, basename(file.path)),
//       });
//       await dio.post("$uploadApi", data: formData);
//       // print(response);
//       // if (response.statusCode == 200) isSuccessfull = true;
//     } catch (e) {
//       print(e);
//       isSuccessfull = false;
//     }
//     return isSuccessfull;
//   }

//   Future<bool> upload(File file) async {
//     bool isSuccessfull;
// // {
// //   "iframeKey": "8c1a237b2b84212be113d71e194bd393",
// //   "apikey": "t0psycr3t3",
// //   "secret": "secret",
// //   "fields": [
// //     {
// //       "key": "first_name",
// //       "value": "videoupload"
// //     }, {
// //       "key": "larst_name",
// //       "value": "videoupload"
// //     }, {
// //       "key": "test",
// //       "value": "videoupload"
// //     }, {
// //       "key": "checkboxtest",
// //       "value": "true"
// //     }, {
// //       "key": "email_address",
// //       "value": "anvar.akramov@gmail.com"
// //     }
// //   ]
// // }

//     try {
//       Map<String, String> fields = {
//         "apikey": "t0psycr3t3",
//         // "iframeKey": "2cda98e067ead6c88f4b560dcc2531bd",
//         "iframeKey": "8c1a237b2b84212be113d71e194bd393",
//         "first_name": "Durdona",
//         "last_name": "Bakhronova",
//         "email_address": "test@gmail.com",
//         "checkboxtest": "true",
//         "promotion_items": "aaaaaaaaaaa",
//         "secret": "secret"
//       };
//       Map<String, dynamic> body = {
//         "iframeKey": "8c1a237b2b84212be113d71e194bd393",
//         "apikey": "t0psycr3t3",
//         "secret": "secret",
//         "fields": [
//           {"key": "first_name", "value": "videoupload"},
//           {"key": "larst_name", "value": "videoupload"},
//           {"key": "test", "value": "videoupload"},
//           {"key": "checkboxtest", "value": "true"},
//           {"key": "email_address", "value": "something@gmail.com"}
//         ],
//       };
//       // open a bytestream
//       var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
//       // get file length
//       var length = await file.length();
//       print(length);
//       // string to uri
//       var uri = Uri.parse(uploadApi);

//       // create multipart request
//       var request = new http.MultipartRequest("POST", uri);
//       request.fields.addAll(body);

//       // multipart that takes file
//       var multipartFile = new http.MultipartFile('file', stream, length,
//           filename: basename(file.path));

//       // add file to multipart
//       request.files.add(multipartFile);
//       // send
//       var response = await request.send().then((result) {
//         result.statusCode == 200 ? isSuccessfull = true : isSuccessfull = false;
//       });
//       print(response.statusCode);

//       // listen for response
//       response.stream.transform(utf8.decoder).listen((value) {
//         print(value);
//       });
//     } catch (e) {
//       print(e);
//     }

//     return isSuccessfull;
//   }

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

  Sink<int> get getBottomVanigationIndex =>
      _getBottomVanigationIndexController.sink;

  final _getBottomVanigationIndexController = StreamController<int>();

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

  Stream<List<String>> get videosList => _videosListSubject.stream;

  final _videosListSubject = BehaviorSubject<List<String>>();

  Stream<int> get navigationbarIndex => _navigationbarIndexSubject.stream;

  final _navigationbarIndexSubject = BehaviorSubject<int>();

  Stream<UploadFileDetailes> get downloadDetails =>
      _downloadDetailsSubject.stream;

  final _downloadDetailsSubject = BehaviorSubject<UploadFileDetailes>();

  FileUploadBloc() {
    getEventPhotosFromServerList();
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
    _getBottomVanigationIndexController.stream.listen((val) {
      _navigationbarIndexSubject.add(val);
      navigationIndex = val;
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
    _getBottomVanigationIndexController.close();
    _navigationbarIndexSubject.close();
    _videosListSubject.close();
    _photosListSubject.close();
    _downloadDetailsSubject.close();
  }
}
