class EventFilesModel {
  String errorMessage;
  int totalCount;
  int count;
  int page;
  List<Photos> photos;

  //   "error_message": null,
  // "total_count": 3,
  // "count": 0,
  // "page": 1,
  // "photos": []
  EventFilesModel(
      {this.errorMessage, this.totalCount, this.count, this.page, this.photos});
  factory EventFilesModel.fromJson(Map<String, dynamic> json) {
    return EventFilesModel(
      errorMessage: json["error_message"] ?? "",
      totalCount: json["total_count"] ?? 0,
      count: json["count"] ?? 0,
      page: json["page"] ?? 0,
      photos: json["photos"]
              .map<Photos>((item) => Photos.fromJson(item))
              .toList() ??
          <Photos>[],
    );
  }
}

class Photos {
  int id;
  String url;
  bool hidden;
  Photos({this.id, this.url, this.hidden});

  factory Photos.fromJson(Map<String, dynamic> json) {
    return Photos(
        id: json["id"] ?? 0,
        url: json["url"] ?? "",
        hidden: json["hidden"] ?? false);
  }
}
