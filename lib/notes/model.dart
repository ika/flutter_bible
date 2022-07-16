class NtModel {
  int id;
  int time;
  String contents;

  NtModel({this.id, this.contents, this.time});

  // Create a Note from JSON data
  factory NtModel.fromJson(Map<String, dynamic> json) => NtModel(
        id: json["id"],
        time: json["time"],
        contents: json["contents"],
      );

  // Convert our Note to JSON to make it easier when we store it in the database
  Map<String, dynamic> toJson() => {
        "id": id,
        "time": time,
        "contents": contents,
      };
}
