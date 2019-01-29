import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

// void savePhoto(filePath) async {
//   print(filePath);
//   var imagePath = await ImagePickerSaver.saveFile(fileData: filePath);
// }

// void saveVideo(filePath) async {
//   print(filePath);
//   var videoPath = await ImagePickerSaver.saveFile(fileData: filePath);
// }
// var _currentDirectory = '';
List<FileSystemEntity> _allPathsList;
const platform = const MethodChannel('com.bakhronova.flutter.fileopener');

//Temporary list before merging into one list
List<String> _directoriesList = List();
List<String> _filesList = List();

List<String> _filteredPathsList = List();
Future<Directory> getDirectory() async {
  var directory = await getApplicationDocumentsDirectory();
  return directory;
}

Future<List<String>> getPhotosList(String mainDirectory) async {
  // await checkPermission();
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
    _directoriesList.sort();
    _filesList.sort();

    _filteredPathsList = _directoriesList + _filesList;
    // if (_directory != mainDirectory) _filteredPathsList.insert(0, _back);
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
// checkPermission() async {
//     if (Platform.isAndroid) {
//       SimplePermissions.checkPermission(Permission.WriteExternalStorage)
//           .then((checkOkay) {
//         if (!checkOkay) {
//           SimplePermissions.requestPermission(Permission.WriteExternalStorage)
//               .then((okDone) {
//             if (okDone == PermissionStatus.authorized) {
//               externalStoragePermissionOkay = true;

//               setState(() {
//                 externalStoragePermissionOkay = true;
//               });
//             }
//           });
//         } else {
//           externalStoragePermissionOkay = checkOkay;
//           setState(() {});
//         }
//       });
//     }
//   }
