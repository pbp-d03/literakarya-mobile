import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:literakarya_mobile/authentication/login.dart';
import 'dart:convert';
import 'package:literakarya_mobile/ereading/models/ereading.dart';
import 'package:literakarya_mobile/ereading/widgets/admin_ereading_card.dart';
import 'package:literakarya_mobile/homepage/drawer.dart';

class EreadingAdminPage extends StatefulWidget {
  const EreadingAdminPage({super.key});

  @override
  State<EreadingAdminPage> createState() => _EreadingAdminPageState();
}

class _EreadingAdminPageState extends State<EreadingAdminPage> {
  Future<List<Ereading>> fetchEreading() async {
    String uname = LoginPage.uname;
    var url = Uri.parse(
        'https://literakarya-d03-tk.pbp.cs.ui.ac.id/ereading/get-json/$uname/');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      List<Ereading> listEreading = [];
      if (data is List) {
        for (var d in data) {
          if (d != null) {
            if (Ereading.fromJson(d).fields.state == 0) {
              listEreading.add(Ereading.fromJson(d));
            }
          }
        }
      }
      return listEreading;
    } else {
      return [];
    }
  }

  Future<void> acceptEreading(int index, List<Ereading> ereadings) async {
    var url = Uri.parse(
        'https://literakarya-d03-tk.pbp.cs.ui.ac.id/ereading/accept-ereading/');
    var response =
        await http.post(url, body: {'id': ereadings[index].pk.toString()});

    if (!mounted) return;
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ereading diterima.')),
      );
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan, silakan coba lagi.')),
      );
    }
  }

  Future<void> rejectEreading(int index, List<Ereading> ereadings) async {
    var url = Uri.parse(
        'https://literakarya-d03-tk.pbp.cs.ui.ac.id/ereading/reject-ereading/');
    var response =
        await http.post(url, body: {'id': ereadings[index].pk.toString()});

    if (!mounted) return;
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ereading ditolak.')),
      );
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan, silakan coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ereading',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal.shade400,
        foregroundColor: Colors.white,
      ),
      drawer: buildDrawer(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                color: Colors.teal.shade100,
                elevation: 5,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Hai Admin LiteraKarya! Berikut ini adalah daftar bacaan digital yang harus kamu periksa.",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder(
                  future: fetchEreading(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.data == null ||
                        snapshot.data.length == 0) {
                      return const Center(
                        child: Text(
                          "Tidak ada Ereading yang harus diperiksa.",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, index) {
                          return AdminEreadingCard(
                              data: snapshot.data!,
                              index: index,
                              onAccept: acceptEreading,
                              onReject: rejectEreading);
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
