// To parse this JSON data, do
//
//     final note = noteFromJson(jsonString);

import 'dart:convert';

List<Note> noteFromJson(String str) => List<Note>.from(json.decode(str).map((x) => Note.fromJson(x)));

String noteToJson(List<Note> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Note {
    String model;
    int pk;
    Fields fields;

    Note({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Note.fromJson(Map<String, dynamic> json) => Note(
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
    DateTime dateAdded;
    int user;
    String judulCatatan;
    String judulBuku;
    String isiCatatan;
    String penanda;
    dynamic buku;

    Fields({
        required this.dateAdded,
        required this.user,
        required this.judulCatatan,
        required this.judulBuku,
        required this.isiCatatan,
        required this.penanda,
        required this.buku,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        dateAdded: DateTime.parse(json["date_added"]),
        user: json["user"],
        judulCatatan: json["judul_catatan"],
        judulBuku: json["judul_buku"],
        isiCatatan: json["isi_catatan"],
        penanda: json["penanda"],
        buku: json["buku"],
    );

    Map<String, dynamic> toJson() => {
        "date_added": "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}",
        "user": user,
        "judul_catatan": judulCatatan,
        "judul_buku": judulBuku,
        "isi_catatan": isiCatatan,
        "penanda": penanda,
        "buku": buku,
    };
}
