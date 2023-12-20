// All
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:literakarya_mobile/authentication/login.dart';
import 'package:literakarya_mobile/forum/models/post.dart';
import 'package:literakarya_mobile/forum/screens/addpost.dart';
import 'package:literakarya_mobile/forum/screens/detailpost.dart';
// import 'package:literakarya_mobile/book_page/screen/list_buku.dart';
import 'package:literakarya_mobile/homepage/drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  Future<List<Post>> fetchPost() async {
    var url = Uri.parse(
        'https://literakarya-d03-tk.pbp.cs.ui.ac.id/forum/json/all-posts/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Post> list_post = [];
    for (var d in data) {
      if (d != null) {
        list_post.add(Post.fromJson(d));
      }
    }
    return list_post.reversed.toList();
  }
  Future<void> deletePost(int postId, CookieRequest request) async {
      final Uri url = Uri.parse('https://literakarya-d03-tk.pbp.cs.ui.ac.id/forum/delete-post-flutter/$postId/');
      final response = await http.delete(url);
      if (response.statusCode == 204) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForumPage()),
        );
      } else {
        print('Failed to delete post, status code: ${response.statusCode}');
      }
    }

  @override
  Widget build(BuildContext context) {
  final request = context.watch<CookieRequest>();
    return Scaffold(
    appBar: AppBar(
      title: Text(
        'Forum',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPostPage(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.greenAccent, Colors.blueGrey]),
              borderRadius: BorderRadius.circular(0),
              boxShadow: const [
                BoxShadow(color: Colors.black, blurRadius: 2.0)
              ]),
          child: Center(
              child: FutureBuilder(
                  future: fetchPost(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (!snapshot.hasData) {
                        return const Column(
                          children: [
                            Text(
                              "Belum ada post.",
                              style: TextStyle(
                                  color: Color(0xff59A5D8), fontSize: 20),
                            ),
                            SizedBox(height: 8),
                          ],
                        );
                      } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (_, index) => InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPostPage(item: snapshot.data![index]),
                                  ),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${snapshot.data![index].fields.subject}",
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (LoginPage.uname == snapshot.data![index].fields.user)
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () async {
                                              int idPost = snapshot.data![index].pk;
                                              await deletePost(idPost, request);
                                            },
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    RichText(
                                      text: TextSpan(
                                        text: 'diunggah oleh ',
                                        style: DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: '${snapshot.data![index].fields.user}',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(text: ' · ${snapshot.data![index].fields.date}'),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "${snapshot.data![index].fields.topic}" == "Pilih Judul Buku"
                                          ? "Literasi umum"
                                          : "${snapshot.data![index].fields.topic}",
                                    ),
                                    // const SizedBox(height: 10),
                                    // Text("${snapshot.data![index].fields.message}"),
                                  ],
                                ),
                              ),
                            ),
                          );
                      }
                    }
                  }))),
    );
  }
}

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("Forum"),
  //     ),
  //     drawer: buildDrawer(context),
  //       floatingActionButton: FloatingActionButton(
  //       onPressed: () {
  //         // Add your onPressed code here...
  //       },
  //       child: Icon(Icons.add),
  //       backgroundColor: Colors.green,
  //     ),
  //     body: Center(
  //       child: Container(
  //           decoration: BoxDecoration(
  //               gradient: LinearGradient(
  //                   begin: Alignment.centerLeft,
  //                   end: Alignment.centerRight,
  //                   colors: [Colors.greenAccent, Colors.blueGrey]),
  //               borderRadius: BorderRadius.circular(0),
  //               boxShadow: const [
  //                 BoxShadow(color: Colors.black, blurRadius: 2.0)
  //               ]),
  //           child: Column(
  //             children: [
  //               SizedBox(height: 10),
  //               Column(
  //                 children: [
  //                   Container(
  //                     width: MediaQuery.of(context).size.width,
  //                     margin: const EdgeInsets.symmetric(
  //                         horizontal: 20, vertical: 6),
  //                     padding: EdgeInsets.all(20),
  //                     decoration: BoxDecoration(
  //                         color: const Color(0xFFDF826C),
  //                         borderRadius: BorderRadius.circular(20)),
  //                     child: Text(
  //                       "Ingat ${LoginPage.uname}, kalau penulis favoritmu itu tidak akan membantumu mengejakan TP SDA, maka tidak usah terlalu dibela 👍",
  //                     style: TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold)),
  //                   ),
  //                 ],
  //               ),
                
  //             ],
  //           )),
  //       // MULAI KERJAIN DARI SINI YA
  //     ),
  //   );
  // }

