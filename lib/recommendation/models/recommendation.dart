// To parse this JSON data, do
//
//     final rekomendasi = rekomendasiFromJson(jsonString);

import 'dart:convert';

List<Rekomendasi> rekomendasiFromJson(String str) => List<Rekomendasi>.from(json.decode(str).map((x) => Rekomendasi.fromJson(x)));

String rekomendasiToJson(List<Rekomendasi> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Rekomendasi {
    String model;
    int pk;
    Fields fields;

    Rekomendasi({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Rekomendasi.fromJson(Map<String, dynamic> json) => Rekomendasi(
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
    int user;
    String gambarBuku;
    String genreBuku;
    String judulBuku;
    String nilaiBuku;
    String isiRekomendasi;
    DateTime tanggal;
    List<int> likes;

    Fields({
        required this.user,
        required this.gambarBuku,
        required this.genreBuku,
        required this.judulBuku,
        required this.nilaiBuku,
        required this.isiRekomendasi,
        required this.tanggal,
        required this.likes,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        gambarBuku: json["gambar_buku"],
        genreBuku: json["genre_buku"],
        judulBuku: json["judul_buku"],
        nilaiBuku: json["nilai_buku"],
        isiRekomendasi: json["isi_rekomendasi"],
        tanggal: DateTime.parse(json["tanggal"]),
        likes: List<int>.from(json["likes"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "gambar_buku": gambarBuku,
        "genre_buku": genreBuku,
        "judul_buku": judulBuku,
        "nilai_buku": nilaiBuku,
        "isi_rekomendasi": isiRekomendasi,
        "tanggal": tanggal.toIso8601String(),
        "likes": List<dynamic>.from(likes.map((x) => x)),
    };
}
