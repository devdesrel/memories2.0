import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:memories/constants.dart';

void showDownloadProgress(received, total) {
  if (total != -1) {
    print((received / total * 100).toStringAsFixed(0) + "%");
  }
}

uploadDio() async {
  var dio = Dio();
  dio.options.baseUrl = "$uploadApi";
  dio.interceptors.add(LogInterceptor(requestBody: true));
  FormData formData = FormData.from({
    "name": "wendux",
    "age": 25,
    "file": UploadFileInfo(File("./example/upload.txt"), "upload.txt"),
    "file2": UploadFileInfo.fromBytes(utf8.encode("hello world"), "word.txt"),
    "files": [
      UploadFileInfo(File("./example/upload.txt"), "upload.txt"),
      UploadFileInfo(File("./example/upload.txt"), "upload.txt")
    ]
  });

  Response response;

  response = await dio.post("/upload",
      data: formData,
      onSendProgress: showDownloadProgress,
      cancelToken: CancelToken());
  if (response.statusCode == 200) {}
}
