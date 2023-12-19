import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:literakarya_mobile/homepage/drawer.dart';
import 'package:literakarya_mobile/notes/screens/list_notes.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class NoteFormPage extends StatefulWidget {
  const NoteFormPage({super.key});

  @override
  State<NoteFormPage> createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _judulCatatan = "";
  String _judulBuku = "";
  String _isiCatatan = "";
  String _penanda = "";
  List<String> _bookTitles = []; // List to store book titles
  String _selectedBookTitle = ""; // Variable to store the selected book title
  double _adjustFontSize(String title) {
    int titleLength = title.length;
    
    double fontSize = 16;

    if (titleLength > 20) {
      fontSize = 12;
    }
    if (titleLength > 30) {
      fontSize = 10;
    }
     return fontSize;
  }

  @override
  void initState() {
    super.initState();
    _fetchBookTitles(); // Fetch book titles on init
  }

  Future<void> _fetchBookTitles() async {
    final url = 'https://literakarya-d03-tk.pbp.cs.ui.ac.id/books/api/';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> books = json.decode(response.body);
        setState(() {
          _bookTitles = books.map((book) => book['fields']['nama_buku'].toString()).toList();
          _bookTitles.sort(); 
        });
      } else {
        print('Failed to load book titles with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to load book titles with error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Buat Catatan',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 38, 166, 154),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      drawer: buildDrawer(context),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          child: ListView(
            shrinkWrap: true, // Important to prevent ListView from expanding infinitely
            children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Judul Catatan",
                  labelText: "Judul Catatan",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _judulCatatan = value!;
                  });
                },
                onSaved: (String? value) {
                  setState(() {
                    _judulCatatan = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Judul catatan tidak boleh kosong!";
                  }
                  return null;
                },
              ),
            ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container( // Wrap the DropdownButtonFormField in a Container
                    width: MediaQuery.of(context).size.width * 0.9, // Adjust the width
                    child: DropdownButtonFormField<String>(
                      isDense: true, 
                      value: _selectedBookTitle.isEmpty ? null : _selectedBookTitle,
                      decoration: InputDecoration(
                        labelText: "Judul Buku",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      items: _bookTitles.isEmpty
                          ? [DropdownMenuItem<String>(value: null, child: Text('Judul Buku'))]
                          : _bookTitles.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(fontSize: _adjustFontSize(value)), // Dynamic font size
                              ),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedBookTitle = newValue ?? '';
                          _judulBuku = newValue ?? '';
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Judul buku tidak boleh kosong!";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Isi Catatan",
                  labelText: "Isi Catatan",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _isiCatatan = value!;
                  });
                },
                onSaved: (String? value) {
                  setState(() {
                    _isiCatatan = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Isi catatan tidak boleh kosong!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Penanda",
                  labelText: "Penanda",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _penanda = value!;
                  });
                },
                onSaved: (String? value) {
                  setState(() {
                    _penanda = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Masukkan penanda catatan!";
                  }
                  return null;
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05), 
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.teal.shade400),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final response = await request.postJson(
                          "https://literakarya-d03-tk.pbp.cs.ui.ac.id/notes/create-flutter/",
                          jsonEncode(<String, String>{
                            'judul_catatan' : _judulCatatan,
                            'judul_buku': _judulBuku,
                            'isi_catatan': _isiCatatan,
                            'penanda': _penanda,
                          }));
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Catatan Anda berhasil disimpan."),
                        ));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const NotesPage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Gagal, silakan coba lagi!"),
                        ));
                      }
                    }
                  },
                  child: const Text(
                    "Simpan",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    )
    );
  }
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
