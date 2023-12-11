import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literakarya_mobile/authentication/login.dart';
import 'package:literakarya_mobile/book_page/model/books.dart';
import 'package:literakarya_mobile/book_page/screen/komen.dart';
import 'package:literakarya_mobile/homepage/drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class SingleBook extends StatefulWidget {
  final Book data;

  SingleBook({required this.data});

  @override
  State<SingleBook> createState() => _SingleBookState();
}

class _SingleBookState extends State<SingleBook> {
  Color warna = Colors.green;
  String uname = LoginPage.uname;
  String bookmark = "AddBookmark";

  Widget buildGenreContainer(String genre) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        genre,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int idPassing = widget.data.pk;

    // print(bookmark);
    final request = context.watch<CookieRequest>();
    return Scaffold(
        backgroundColor: Colors.green[100],
        appBar: AppBar(
          title: Text("Detail"),
        ),
        drawer: buildDrawer(context),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.greenAccent, Colors.blueGrey]),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(0.0))),
            padding: const EdgeInsets.only(
                right: 20.0, left: 20.0, top: 35.0, bottom: 30.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              padding: EdgeInsets.only(
                  right: 40.0, left: 40.0, top: 20.0, bottom: 20.0),
              child: Column(
                children: <Widget>[
                  Container(
                      height: 80.0,
                      padding: EdgeInsets.all(20.0),
                      child: Text("${widget.data.fields.namaBuku}",
                          style: TextStyle(
                              fontSize: 25,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w800,
                              color: Colors.black))),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.network(
                      widget.data.fields.gambarBuku,
                      width: 150.0,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Add BOOKMARK
                  ElevatedButton(
                      onPressed: () async {
                        if (bookmark == "AddBookmark") {
                          final response = await request.postJson(
                              "https://literakarya-d03-tk.pbp.cs.ui.ac.id/books/add-bookmark-flutter/$uname/",
                              jsonEncode(<String, int>{
                                'idBuku': idPassing,
                                // TODO: Sesuaikan field data sesuai dengan aplikasimu
                              }));
                          setState(() {
                            bookmark = "DeleteBookmark";
                            warna = Colors.red;
                          });
                        } else {
                          final response = await request.postJson(
                              "https://literakarya-d03-tk.pbp.cs.ui.ac.id/books/delete-bookmark-flutter/$uname/",
                              jsonEncode(<String, int>{
                                'idBuku': idPassing
                                // TODO: Sesuaikan field data sesuai dengan aplikasimu
                              }));
                          setState(() {
                            bookmark = "AddBookmark";
                            warna = Colors.green;
                          });
                        }
                      },
                      child: Text(
                        "$bookmark",
                        style: TextStyle(
                            color: warna,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            height: 1.5),
                      )),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 85, 107, 231),
                        foregroundColor: Colors.white),
                    onPressed: () {
                      // Route menu ke counter
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TestMe(
                                  idBuku: widget.data.pk,
                                  judulBuku: widget.data.fields.namaBuku,
                                )),
                      );
                    },
                    child: const Text(
                      'Komen Buku',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Align(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ============================= AUTHOR & RATINGS ================================
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // AUTHOR
                            Row(children: [
                              Icon(Icons.person, color: Colors.green[600]),
                              Text("${widget.data.fields.author}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.green[600]))
                            ]),
                            SizedBox(height: 10),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    Icon(Icons.pages, color: Colors.blue),
                                    Text(
                                        "${widget.data.fields.jumlahHalaman} halaman",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.blue))
                                  ]),
                                  Row(children: [
                                    Icon(Icons.rate_review,
                                        color: Colors.red[600]),
                                    Text("${widget.data.fields.rating} ",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700)),
                                    Text(
                                        "by ${widget.data.fields.jumlahRating} reviewers",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal)),
                                  ])
                                ]),
                          ]),
                      // ============================= Genres ================================
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Icon(Icons.category, color: Colors.orange[600]),
                            Text("Genres ",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.orange[600]))
                          ]),
                          SizedBox(height: 10),
                          Wrap(
                            spacing:
                                10.0, // Adjust the spacing between genre containers
                            runSpacing:
                                10.0, // Adjust the spacing between lines of genre containers
                            children: [
                              buildGenreContainer(widget.data.fields.genre1),
                              buildGenreContainer(widget.data.fields.genre2),
                              buildGenreContainer(widget.data.fields.genre3),
                              buildGenreContainer(widget.data.fields.genre4),
                              buildGenreContainer(widget.data.fields.genre5),
                            ],
                          ),
                        ],
                      ),
                      // ============================= DESCRIPTION ================================
                      SizedBox(height: 10),
                      Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Description",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black)),
                                SizedBox(height: 10),
                                Text("${widget.data.fields.description}",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black))
                              ])),
                    ],
                  )),
                ],
              ),
            ),
          ),
        ));
  }
}

// References:
// *) https://medium.com/flutter-community/simple-ways-to-pass-to-and-share-data-with-widgets-pages-f8988534bd5b
// *) https://dev.to/thepythongeeks/how-to-make-a-clickable-container-in-flutter-1953
// *) https://www.fluttercampus.com/guide/84/how-to-change-font-style-of-text-widget-flutter/
// *) https://stackoverflow.com/questions/54513641/flutterwhy-my-column-alignment-is-always-center