// To parse this JSON data, do
//
//     final reply = replyFromJson(jsonString);

import 'dart:convert';

List<Reply> replyFromJson(String str) => List<Reply>.from(json.decode(str).map((x) => Reply.fromJson(x)));

String replyToJson(List<Reply> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Reply {
    int pk;
    Fields fields;

    Reply({
        required this.pk,
        required this.fields,
    });

    factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String user;
    int post;
    String body;
    String date;

    Fields({
        required this.user,
        required this.post,
        required this.body,
        required this.date,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        post: json["post"],
        body: json["body"],
        date: json["date"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "post": post,
        "body": body,
        "date": date,
    };
}
