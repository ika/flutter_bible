// @dart=2.9

// Notes model

class NModel {
  int id;
  int time;
  String title;
  String subtitle;

  NModel({this.id, this.title, this.subtitle, this.time});

  // Create a Note from JSON data
  factory NModel.fromJson(Map<String, dynamic> json) => NModel(
        id: json["id"],
        time: json["time"],
        title: json["title"],
        subtitle: json["subtitle"]
      );

  // Convert our Note to JSON to make it easier when we store it in the database
  Map<String, dynamic> toJson() => {
        "id": id,
        "time": time,
        "title": title,
        "subtitle": subtitle
      };
}
