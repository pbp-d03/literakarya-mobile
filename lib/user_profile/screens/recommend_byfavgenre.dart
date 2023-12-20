import 'package:flutter/material.dart';
import 'package:literakarya_mobile/authentication/login.dart';
import 'package:literakarya_mobile/book_page/model/books.dart';
import 'package:literakarya_mobile/book_page/screen/onebuku.dart';
import 'package:literakarya_mobile/homepage/drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:literakarya_mobile/user_profile/models/profile.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class RecommendForYou extends StatefulWidget {
  const RecommendForYou({super.key});

  @override
  State<RecommendForYou> createState() => _RecommendForYouState();
}

class _RecommendForYouState extends State<RecommendForYou> {
  String genre = "";
  String uname = LoginPage.uname;
  List<Profile> profiles = [];
  List<String> userFavGenres = [];

  Future<void> fetchProfile(request) async {
    try {
      var data = await request.get('https://literakarya-d03-tk.pbp.cs.ui.ac.id/user_profile/json/');
      List<Profile> listProfile = [];
      for (var d in data) {
        if (d != null) {
          listProfile.add(Profile.fromJson(d));
        }
      }
      setState(() {
        profiles = listProfile;
        Set<String> uniqueGenres = Set<String>();
        uniqueGenres.add(profiles[0].fields.favoriteGenre1);
        uniqueGenres.add(profiles[0].fields.favoriteGenre2);
        uniqueGenres.add(profiles[0].fields.favoriteGenre3);
        userFavGenres = uniqueGenres.toList();
      });
    } catch (e) {
      print('Error fetching profiles: $e');
    }
  }

  Future<List<Book>> fetchBook(List<String> userFavGenres) async {
  // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
  List<Book> list_book = [];
  Set<int> uniqueBookIds = Set<int>();

  for (var genre in userFavGenres) {
    var url;
    if (genre == "") {
      url = Uri.parse('https://literakarya-d03-tk.pbp.cs.ui.ac.id/books/api/');
    } else {
      url = Uri.parse(
          'https://literakarya-d03-tk.pbp.cs.ui.ac.id/books/book-filter/$genre/');
    }

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );
    
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    
    for (var d in data) {
      if (d != null) {
        int bookId = Book.fromJson(d).pk;
        if (!uniqueBookIds.contains(bookId)) {
          uniqueBookIds.add(bookId);
          list_book.add(Book.fromJson(d));
        }
      }
    }
  }
  return list_book;
}


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchProfile(Provider.of<CookieRequest>(context, listen: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.green[100],
        appBar: AppBar(
          title: Text(
            'Profile',
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
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.greenAccent, Colors.blueGrey])),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Haii, ada rekomendasi buku untukmu nih... :)",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                      future: fetchBook(userFavGenres),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          if (!snapshot.hasData) {
                            return Column(
                              children: const [
                                Text(
                                  "Tidak ada buku :(",
                                  style: TextStyle(
                                      color: Color(0xff59A5D8), fontSize: 20),
                                ),
                                SizedBox(height: 8),
                              ],
                            );
                          } else {
                            return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (_, index) {
                                  return InkWell(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 50, vertical: 12),
                                        padding: const EdgeInsets.all(20.0),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.black,
                                                  blurRadius: 2.0)
                                            ]),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              child: Image.network(
                                                snapshot.data![index].fields
                                                    .gambarBuku,
                                                height: 200,
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            Text(
                                              "${snapshot.data![index].fields.namaBuku}",
                                              style: const TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "${snapshot.data![index].fields.author}",
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey),
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                ),
                                                Text(
                                                  " ${snapshot.data![index].fields.rating} Rating",
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SingleBook(
                                                    data: snapshot.data![index],
                                                  )),
                                        );
                                      });
                                });
                          }
                        }
                      }),
                )
              ],
            )));
  }
}