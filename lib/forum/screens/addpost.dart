import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:literakarya_mobile/book_page/model/books.dart';
import 'package:literakarya_mobile/book_page/utils/fetchbook.dart';
import 'package:literakarya_mobile/forum/screens/forum.dart';
import 'dart:convert';
import 'package:literakarya_mobile/homepage/drawer.dart';
import 'package:literakarya_mobile/notes/screens/list_notes.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final _formKey = GlobalKey<FormState>();
  String _subject = "";
  List<String> _books = [];
  String _selectedBook = "";
  String _message = "";
  double _adjustFontSize(String title) {
  int titleLength = title.length;
    double fontSize = 16;
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
          _books = books.map((book) => book['fields']['nama_buku'].toString()).toList();
          _books.sort(); 
          _books.insert(0, "Literasi umum");
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
      title: Text(
        'Tambah Post Baru',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontFamily: 'Sansita',
          fontWeight: FontWeight.w700,
        ),
      ),
        backgroundColor: Colors.teal.shade400,
        foregroundColor: Colors.white,
    ),
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
                  hintText: "Subjek",
                  labelText: "Subjek",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _subject = value!;
                  });
                },
                onSaved: (String? value) {
                  setState(() {
                    _subject = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Subjek tidak boleh kosong!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9, // Adjust width if necessary
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: _selectedBook.isEmpty ? null : _selectedBook,
                  decoration: InputDecoration(
                    labelText: "Judul Buku",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  items: _books.isEmpty
                      ? [DropdownMenuItem<String>(value: null, child: Text('No Books'))]
                      : _books.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              overflow: TextOverflow.ellipsis, // Ini untuk mengelola overflow teks
                              style: TextStyle(fontSize: _adjustFontSize(value)), // Sesuaikan ukuran font jika perlu
                            ),
                          );
                        }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedBook = newValue ?? '';
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
                  hintText: "Tuliskan pesan anda",
                  labelText: "Tuliskan pesan anda",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _message = value!;
                  });
                },
                onSaved: (String? value) {
                  setState(() {
                    _message = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Pesan tidak boleh kosong!";
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
                          "https://literakarya-d03-tk.pbp.cs.ui.ac.id/forum/create-post-flutter/",
                          jsonEncode(<String, String>{
                            'subject' : _subject,
                            'topic': _selectedBook,
                            'message': _message,
                          }));
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Pesan Anda berhasil diunggah."),
                        ));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const ForumPage()),
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
                    "Post",
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
