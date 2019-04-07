class UploadApiResponseModel {
  final String error;
  final String msg;
  final bool success;

  UploadApiResponseModel({this.error, this.msg, this.success});

  factory UploadApiResponseModel.fromJson(Map<String, dynamic> json) {
    return UploadApiResponseModel(
        error: json['error'] ?? '',
        msg: json['msg'] ?? '',
        success: json['success'] ?? false);
  }
}
