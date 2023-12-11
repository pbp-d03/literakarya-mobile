// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:literakarya_mobile/authentication/login.dart';
import 'dart:convert';
import 'package:literakarya_mobile/ereading/models/ereading.dart';
// import 'package:literakarya_mobile/ereading/screens/detail_ereading.dart';
// import 'package:literakarya_mobile/ereading/screens/form_ereading.dart';
import 'package:literakarya_mobile/homepage/drawer.dart';

class EreadingPage extends StatefulWidget {
  const EreadingPage({Key? key}) : super(key: key);

  @override
  _EreadingPageState createState() => _EreadingPageState();
}

class _EreadingPageState extends State<EreadingPage> {
  Future<List<Ereading>> fetchEreading() async {
    // TODO: Ganti URL!
    // var url = Uri.parse('https://kristoforus-adi-tugas.pbp.cs.ui.ac.id/json/');
    String uname = LoginPage.uname;

    var url = Uri.parse('http://localhost:8000/ereading/get-json/$uname/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // Melakukan decode response menjadi bentuk JSON.
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // Melakukan konversi data JSON menjadi object Ereading.
    List<Ereading> listEreading = [];
    for (var d in data) {
      if (d != null) {
        listEreading.add(Ereading.fromJson(d));
      }
    }
    return listEreading;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ereading"),
      ),
      drawer: buildDrawer(context),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.greenAccent, Colors.blueGrey],
              ),
              borderRadius: BorderRadius.circular(0),
              boxShadow: const [
                BoxShadow(color: Colors.black, blurRadius: 2.0),
              ],
            ),
            child: Column(
              children: [
                Container(
                  child: Container(
                    padding: EdgeInsets.all(5),
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 6,
                      ),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        LoginPage.uname != "adminliterakarya"
                            ? "Yuk tambahkan koleksi bacaan digital kamu ke katalog pribadimu di LiteraKarya!"
                            : "Berikut ini adalah daftar bacaan digital yang harus kamu periksa hari ini.",
                      ),
                    ),
                  ],
                ),
                if (LoginPage.uname != "adminliterakarya")
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 6,
                      ),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: fetchEreading(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data == null || snapshot.data.length == 0) {
                  return Column(
                    children: [
                      Text(
                        "Tidak ada data Ereading.",
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
                      if (snapshot.data![index].fields.state == 0) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${snapshot.data![index].fields.title}",
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                  "Status: Bukumu sedang diperiksa oleh admin."),
                            ],
                          ),
                        );
                      } else if (snapshot.data![index].fields.state == 1) {
                        return InkWell(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${snapshot.data![index].fields.title}",
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                    "Author: ${snapshot.data![index].fields.author}"),
                                const SizedBox(height: 10),
                                Text(
                                    "Description: ${snapshot.data![index].fields.description}"),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        );
                      } else if (snapshot.data![index].fields.state == 2) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${snapshot.data![index].fields.title}",
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                  "Status: Bukumu ditolak karena tidak memenuhi ketentuan yang berlaku."),
                            ],
                          ),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
