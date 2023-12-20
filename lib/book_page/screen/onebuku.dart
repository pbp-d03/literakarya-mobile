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
  String bookmark = "Add Bookmark";

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
    appBar: AppBar(
      title: Text(
        'Detail',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
        ),
      ),
        backgroundColor: Colors.teal.shade400,
        foregroundColor: Colors.white,
    ),
        drawer: buildDrawer(context),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.teal.shade200,
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
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 250, 250)),
                      onPressed: () async {
                        if (bookmark == "Add Bookmark") {
                          final response = await request.postJson(
                              "https://literakarya-d03-tk.pbp.cs.ui.ac.id/books/add-bookmark-flutter/$uname/",
                              jsonEncode(<String, int>{
                                'idBuku': idPassing,
                                // TODO: Sesuaikan field data sesuai dengan aplikasimu
                              }));
                          setState(() {
                            bookmark = "Delete Bookmark";
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
                            bookmark = "Add Bookmark";
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
                        backgroundColor: Colors.teal.shade600,
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
                      'Komentar Buku',
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
                      // AUTHOR
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.green[600]),
                          SizedBox(width: 4),
                          Flexible( // Mencegah overflow pada nama author
                            child: Text(
                              "${widget.data.fields.author}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.green[600]
                              )
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      // JUMLAH HALAMAN
                      Row(
                        children: [
                          Icon(Icons.pages, color: Colors.blue),
                          SizedBox(width: 4),
                          Flexible( // Mencegah overflow pada judul halaman
                            child: Text(
                              "${widget.data.fields.jumlahHalaman} halaman",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.blue
                              )
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      // RATING
                      Row(
                        children: [
                          Icon(Icons.rate_review, color: Colors.red[600]),
                          SizedBox(width: 4),
                          Flexible( // Mencegah overflow pada rating
                            child: Text(
                              "${widget.data.fields.rating} by ${widget.data.fields.jumlahRating} reviewers",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontWeight: FontWeight.w700
                              )
                            ),
                          ),
                        ],
                      ),

                      // ============================= Genres ================================
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Row(
                          children: [
                            Icon(Icons.category, color: Colors.orange[600]),
                            SizedBox(width: 4),
                            Flexible( // Mencegah overflow pada genre
                              child: Text(
                                "Genres: ",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.orange[600]
                                )
                              ),
                            ),
                          ],
                        ),
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