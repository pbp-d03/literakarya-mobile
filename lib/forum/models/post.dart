// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

List<Post> postFromJson(String str) => List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

String postToJson(List<Post> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Post {
    int pk;
    Fields fields;

    Post({
        required this.pk,
        required this.fields,
    });

    factory Post.fromJson(Map<String, dynamic> json) => Post(
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
    String subject;
    String topic;
    String message;
    String date;

    Fields({
        required this.user,
        required this.subject,
        required this.topic,
        required this.message,
        required this.date,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        subject: json["subject"],
        topic: json["topic"],
        message: json["message"],
        date: json["date"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "subject": subject,
        "topic": topic,
        "message": message,
        "date": date,
    };
}
