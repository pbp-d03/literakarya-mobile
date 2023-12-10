import 'dart:convert';

List<Ereading> ereadingFromJson(String str) =>
    List<Ereading>.from(json.decode(str).map((x) => Ereading.fromJson(x)));

String ereadingToJson(List<Ereading> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Ereading {
  String model;
  int pk;
  Fields fields;

  Ereading({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Ereading.fromJson(Map<String, dynamic> json) => Ereading(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  String title;
  String author;
  String description;
  String link;
  int user;
  String createdBy;
  DateTime lastUpdated;
  int state;

  Fields({
    required this.title,
    required this.author,
    required this.description,
    required this.link,
    required this.user,
    required this.createdBy,
    required this.lastUpdated,
    required this.state,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        title: json["title"],
        author: json["author"],
        description: json["description"],
        link: json["link"],
        user: json["user"],
        createdBy: json["created_by"],
        lastUpdated: DateTime.parse(json["last_updated"]),
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "author": author,
        "description": description,
        "link": link,
        "user": user,
        "created_by": createdBy,
        "last_updated": lastUpdated.toIso8601String(),
        "state": state,
      };
}
