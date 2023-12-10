// To parse this JSON data, do
//
//     final komen = komenFromJson(jsonString);

import 'dart:convert';

List<Komen> komenFromJson(String str) =>
    List<Komen>.from(json.decode(str).map((x) => Komen.fromJson(x)));

String komenToJson(List<Komen> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Komen {
  String model;
  int pk;
  Fields fields;

  Komen({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Komen.fromJson(Map<String, dynamic> json) => Komen(
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
  String user;
  int buku;
  String isiKomen;
  DateTime dateAdded;
  int likes;
  int dislikes;

  Fields({
    required this.user,
    required this.buku,
    required this.isiKomen,
    required this.dateAdded,
    required this.likes,
    required this.dislikes,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        buku: json["buku"],
        isiKomen: json["isi_komen"],
        dateAdded: DateTime.parse(json["date_added"]),
        likes: json["likes"],
        dislikes: json["dislikes"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "buku": buku,
        "isi_komen": isiKomen,
        "date_added":
            "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}",
        "likes": likes,
        "dislikes": dislikes,
      };
}
