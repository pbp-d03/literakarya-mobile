// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

List<Profile> profileFromJson(String str) => List<Profile>.from(json.decode(str).map((x) => Profile.fromJson(x)));

String profileToJson(List<Profile> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Profile {
    String model;
    int pk;
    Fields fields;

    Profile({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
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
    String firstName;
    String lastName;
    String bio;
    String address;
    String favoriteGenre1;
    String favoriteGenre2;
    String favoriteGenre3;

    Fields({
        required this.user,
        required this.firstName,
        required this.lastName,
        required this.bio,
        required this.address,
        required this.favoriteGenre1,
        required this.favoriteGenre2,
        required this.favoriteGenre3,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        bio: json["bio"],
        address: json["address"],
        favoriteGenre1: json["favorite_genre1"],
        favoriteGenre2: json["favorite_genre2"],
        favoriteGenre3: json["favorite_genre3"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "first_name": firstName,
        "last_name": lastName,
        "bio": bio,
        "address": address,
        "favorite_genre1": favoriteGenre1,
        "favorite_genre2": favoriteGenre2,
        "favorite_genre3": favoriteGenre3,
    };
}
