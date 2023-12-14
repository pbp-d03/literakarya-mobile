// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:literakarya_mobile/authentication/login.dart';
import 'dart:convert';
import 'package:literakarya_mobile/ereading/models/ereading.dart';
import 'package:literakarya_mobile/homepage/drawer.dart';

class EreadingUserPage extends StatefulWidget {
  const EreadingUserPage({Key? key}) : super(key: key);

  @override
  _EreadingUserPageState createState() => _EreadingUserPageState();
}

class _EreadingUserPageState extends State<EreadingUserPage> {
  Future<List<Ereading>> fetchEreading() async {
    String uname = LoginPage.uname;

    var url = Uri.parse('http://localhost:8000/ereading/get-json/$uname/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                color: Colors.black,
                elevation: 5,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Hai ${LoginPage.uname}, yuk tambahkan koleksi bacaan digital kamu ke katalog pribadimu di LiteraKarya!",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Card(
                color: Colors.yellow,
                elevation: 5,
                child: Container(
                  width: 200,
                  child: ListTile(
                    title: Text('Add Ereading',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: FutureBuilder(
                  future: fetchEreading(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.data == null ||
                        snapshot.data.length == 0) {
                      return Center(
                        child: Text(
                          "Tidak ada Ereading yang tersimpan.",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, index) {
                          return Card(
                            elevation: 5,
                            margin: const EdgeInsets.all(8.0),
                            color: snapshot.data![index].fields.state == 1
                                ? Colors.lightGreen[100]
                                : snapshot.data![index].fields.state == 2
                                    ? Colors.orange[100]
                                    : Colors.white,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(height: 3),
                                  Text(
                                    "${snapshot.data![index].fields.title}",
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Status: " +
                                        (snapshot.data![index].fields.state == 0
                                            ? "Bacaanmu sedang diperiksa oleh admin."
                                            : snapshot.data![index].fields
                                                        .state ==
                                                    1
                                                ? "Bacaanmu diterima dan selamat membaca!"
                                                : "Bacaanmu ditolak oleh admin."),
                                    style: const TextStyle(fontSize: 14.0),
                                  ),
                                  SizedBox(height: 3),
                                  Divider(color: Colors.black),
                                  Text(
                                    "Last updated: ${DateFormat('dd/MM/yyyy | hh:mm:ss a').format(snapshot.data![index].fields.lastUpdated)}",
                                    style: const TextStyle(fontSize: 14.0),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
