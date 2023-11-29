// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

import 'dart:convert';

List<Book> bookFromJson(String str) =>
    List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));

String bookToJson(List<Book> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
  Model model;
  int pk;
  Fields fields;

  Book({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  String namaBuku;
  String gambarBuku;
  String author;
  String description;
  double rating;
  String jumlahRating;
  String genre1;
  String genre2;
  String genre3;
  String genre4;
  String genre5;
  int jumlahHalaman;
  String waktuPublikasi;

  Fields({
    required this.namaBuku,
    required this.gambarBuku,
    required this.author,
    required this.description,
    required this.rating,
    required this.jumlahRating,
    required this.genre1,
    required this.genre2,
    required this.genre3,
    required this.genre4,
    required this.genre5,
    required this.jumlahHalaman,
    required this.waktuPublikasi,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        namaBuku: json["nama_buku"],
        gambarBuku: json["gambar_buku"],
        author: json["author"],
        description: json["description"],
        rating: json["rating"]?.toDouble(),
        jumlahRating: json["jumlah_rating"],
        genre1: json["genre_1"],
        genre2: json["genre_2"],
        genre3: json["genre_3"],
        genre4: json["genre_4"],
        genre5: json["genre_5"],
        jumlahHalaman: json["jumlah_halaman"],
        waktuPublikasi: json["waktu_publikasi"],
      );

  Map<String, dynamic> toJson() => {
        "nama_buku": namaBuku,
        "gambar_buku": gambarBuku,
        "author": author,
        "description": description,
        "rating": rating,
        "jumlah_rating": jumlahRating,
        "genre_1": genre1,
        "genre_2": genre2,
        "genre_3": genre3,
        "genre_4": genre4,
        "genre_5": genre5,
        "jumlah_halaman": jumlahHalaman,
        "waktu_publikasi": waktuPublikasi,
      };
}

enum Model { BOOK_PAGE_BOOK }

final modelValues = EnumValues({"book_page.book": Model.BOOK_PAGE_BOOK});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
