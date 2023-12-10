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
  // String genre = "";
  // String genre = "";
  String uname = LoginPage.uname;
  bool val = false;

  // List<Book> listBookmark = [];

  // void getlist() async {
  //   Future<List<Book>> futureList = fetchBookmark(uname);
  //   listBookmark = await futureList;
  //   print(listBookmark);
  // }

  // String dibookmark(int idBuku) {
  //   bool val = false;
  //   getlist();

  //   for (var i = 0; i < listBookmark.length; i++) {
  //     if (listBookmark[i].pk == idBuku) {
  //       setState(() {
  //         val = true;
  //       });
  //       break;
  //     }
  //   }
  //   print(val);
  //   print(listBookmark);
  //   print("AAA");
  //   if (val == true) {
  //     return "DeleteBookmark";
  //   }
  //   return "AddBookmark";
  // }

  @override
  Widget build(BuildContext context) {
    String userName = LoginPage.uname;
    return Scaffold(
        // backgroundColor: Colors.green[100],
        appBar: AppBar(
          title: Text("Daftar Bookmark"),
        ),
        // menambahkan Drawer untuk navigasi antarhalaman
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
                          "Happy Reading ${userName} !!!",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      // SizedBox(
                      //   height: 16.0,
                      // ),
                      // Text(
                      //   "Search for a Genre Book",
                      //   style: TextStyle(
                      //       color: Colors.white,
                      //       fontSize: 16.0,
                      //       fontWeight: FontWeight.bold),
                      // ),
                      // SizedBox(
                      //   height: 10.0,
                      // ),
                      // TextField(
                      //   onChanged: (value) {
                      //     setState(() {
                      //       genre = value;
                      //     });
                      //   },
                      //   style: TextStyle(color: Colors.white),
                      //   decoration: InputDecoration(
                      //       filled: true,
                      //       fillColor: Color.fromARGB(255, 126, 177, 128),
                      //       border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(8.0),
                      //           borderSide: BorderSide.none),
                      //       hintText:
                      //           "eg: Comedy, Fiction, History etc (Gunakan Huruf Kapital Di Awal Kata)",
                      //       prefixIcon: Icon(Icons.search),
                      //       prefixIconColor: Color.fromARGB(255, 62, 166, 66)),
                      // ),
                      // SizedBox(
                      //   height: 16.0,
                      // ),
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                      future: fetchBookmark(userName),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          if (snapshot.data.length == 0) {
                            return Column(
                              children: const [
                                Text(
                                  "Tidak ada buku yang di Bookmark Nih :(",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 222, 238, 249),
                                      fontSize: 20),
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
