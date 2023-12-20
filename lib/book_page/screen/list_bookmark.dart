import 'package:flutter/material.dart';
import 'package:literakarya_mobile/authentication/login.dart';
import 'package:literakarya_mobile/book_page/model/books.dart';
import 'package:literakarya_mobile/book_page/screen/onebuku.dart';
import 'package:literakarya_mobile/book_page/utils/fetchbook.dart';
import 'package:literakarya_mobile/book_page/utils/fetchbookmark.dart';
import 'package:literakarya_mobile/homepage/drawer.dart';

class DaftarBookmark extends StatefulWidget {
  const DaftarBookmark({super.key});

  @override
  State<DaftarBookmark> createState() => _DaftarBookmarkState();
}

class _DaftarBookmarkState extends State<DaftarBookmark> {
  String uname = LoginPage.uname;
  bool val = false;

  @override
  Widget build(BuildContext context) {
    String userName = LoginPage.uname;
    return Scaffold(
    appBar: AppBar(
      title: Text(
        'Daftar Bookmark',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
      ),
        backgroundColor: Colors.teal.shade400,
        foregroundColor: Colors.white,
    ),
        // menambahkan Drawer untuk navigasi antarhalaman
        drawer: buildDrawer(context),
        body: Container(
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
                      "Happy Reading ${userName} !!!",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: fetchBookmark(userName),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.data.length == 0) {
                        return Column(
                          children: const [
                            Text(
                              "Tidak ada buku yang di Simpan Nih :(",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
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
                                            snapshot
                                                .data![index].fields.gambarBuku,
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
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SingleBook(
                                                data: snapshot.data![index],
                                                // dibookmark: dibookmark(
                                                //     snapshot
                                                //         .data![index].pk),
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
