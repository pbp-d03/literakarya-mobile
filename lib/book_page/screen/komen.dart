import 'dart:convert';

import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:literakarya_mobile/authentication/login.dart';
import 'package:literakarya_mobile/book_page/model/books.dart';
import 'package:literakarya_mobile/book_page/model/comment.dart';
import 'package:literakarya_mobile/book_page/utils/fetchkomen.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class TestMe extends StatefulWidget {
  final int idBuku;
  final String judulBuku;
  TestMe({required this.idBuku, required this.judulBuku});

  @override
  _TestMeState createState() => _TestMeState();
}

class _TestMeState extends State<TestMe> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  String userLogin = LoginPage.uname;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    int idBukuPassing = widget.idBuku;
    String judul = widget.judulBuku;
    // String userName = LoginPage.uname;

    return Scaffold(
      appBar: AppBar(
        title: Text("Komen Book: ${judul}"),
        backgroundColor: const Color.fromARGB(255, 30, 233, 125),
      ),
      body: Container(
        child: CommentBox(
          child: FutureBuilder(
              future: fetchKomen(idBukuPassing),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (!snapshot.hasData) {
                    return Column(
                      children: const [
                        Text(
                          "Tidak ada buku :(",
                          style:
                              TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                        ),
                        SizedBox(height: 8),
                      ],
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
                            child: ListTile(
                                leading: GestureDetector(
                                  onTap: () async {
                                    // print("Comment Clicked");
                                  },
                                  child: Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: new BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: new BorderRadius.all(
                                            Radius.circular(50.0))),
                                    child: CircleAvatar(
                                      radius: 50.0,
                                      child: Icon(Icons.person,
                                          size: 40.0, color: Colors.white),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  snapshot.data[index].fields.user,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle:
                                    Text(snapshot.data[index].fields.isiKomen),
                                trailing: Column(
                                  children: [
                                    Text(
                                        "${snapshot.data[index].fields.dateAdded}",
                                        style: TextStyle(fontSize: 10)),
                                    SizedBox(height: 8),
                                    GestureDetector(
                                      child: Icon(
                                        userLogin == "adminliterakarya"
                                            ? Icons.delete
                                            : Icons.emoji_emotions,
                                        color: userLogin == "adminliterakarya"
                                            ? Colors.black
                                            : Colors.yellow,
                                      ),
                                      onTap: () async {
                                        int idKomen = snapshot.data[index].pk;
                                        if (userLogin == "adminliterakarya") {
                                          final response = await request.postJson(
                                              "http://127.0.0.1:8000/books/delete-komen-flutter/",
                                              jsonEncode(<String, int>{
                                                'idKomen': idKomen,
                                                // TODO: Sesuaikan field data sesuai dengan aplikasimu
                                              }));
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => TestMe(
                                                    idBuku: idBukuPassing,
                                                    judulBuku: judul)),
                                          );
                                        }
                                      },
                                    )
                                  ],
                                )),
                          );
                        });
                  }
                }
              }),
          labelText: 'Write a comment...',
          errorText: 'Comment cannot be blank',
          withBorder: false,
          sendButtonMethod: () async {
            if (formKey.currentState!.validate()) {
              // print(commentController.text);
              final response = await request.postJson(
                  "http://127.0.0.1:8000/books/add-komen-flutter/$idBukuPassing/",
                  jsonEncode(<String, String>{
                    'isi_komen': commentController.text
                    // TODO: Sesuaikan field data sesuai dengan aplikasimu
                  }));
              commentController.clear();
              FocusScope.of(context).unfocus();
            } else {
              print("Not validated");
            }
          },
          formKey: formKey,
          commentController: commentController,
          backgroundColor: const Color.fromARGB(255, 57, 233, 30),
          textColor: Colors.white,
          sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.white),
        ),
      ),
    );
  }
}
