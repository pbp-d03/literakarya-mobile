import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:literakarya_mobile/homepage/drawer.dart';
import 'package:literakarya_mobile/notes/models/note.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:literakarya_mobile/notes/screens/list_notes.dart';

class EditNotePage extends StatefulWidget {
  final Note note;
  const EditNotePage({Key? key, required this.note}) : super(key: key);

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late String _judulCatatan;
  late String _judulBuku;
  late String _isiCatatan;
  late String _penanda;
  List<String> _bookTitles = [];
  String _selectedBookTitle = "";

  @override
  void initState() {
    super.initState();
    _fetchBookTitles();
    _initializeFormData();
  }

  void _initializeFormData() {
    _judulCatatan = widget.note.fields.judulCatatan;
    _judulBuku = widget.note.fields.judulBuku;
    _isiCatatan = widget.note.fields.isiCatatan;
    _penanda = widget.note.fields.penanda;
    _selectedBookTitle = widget.note.fields.judulBuku;
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
    int idNote = widget.note.pk;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Edit Catatan',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 33, 30, 233),
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
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: _judulCatatan,
                decoration: InputDecoration(
                  hintText: "Judul Catatan",
                  labelText: "Judul Catatan",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) => _judulCatatan = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Judul catatan tidak boleh kosong!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: _selectedBookTitle,
                decoration: InputDecoration(
                  labelText: "Judul Buku",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                items: _bookTitles.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedBookTitle = newValue!;
                    _judulBuku = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Judul buku tidak boleh kosong!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: _isiCatatan,
                decoration: InputDecoration(
                  hintText: "Isi Catatan",
                  labelText: "Isi Catatan",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) => _isiCatatan = value,
                validator: (value) {
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
                initialValue: _penanda,
                decoration: InputDecoration(
                  hintText: "Penanda",
                  labelText: "Penanda",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) => _penanda = value,
                validator: (value) {
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
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue.shade700),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final response = await request.postJson(
                          "https://literakarya-d03-tk.pbp.cs.ui.ac.id/notes/edit-note-flutter/$idNote/",
                          jsonEncode(<String, String>{
                            'judul_catatan' : _judulCatatan,
                            'judul_buku': _judulBuku,
                            'isi_catatan': _isiCatatan,
                            'penanda': _penanda,
                          }));
                      if (response.statusCode == 200) {
                        final responseData = json.decode(response.body);
                        if (responseData['status'] == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Catatan Anda berhasil diupdate."))
                          );
                          Navigator.pop(context); // Kembali ke halaman sebelumnya (detail_notes.dart)
                          Navigator.popAndPushNamed(context, '/list_notes'); // Perbarui halaman list_notes
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Gagal, silakan coba lagi!"))
                          );
                        }
                      } else {
                        print('Failed to update note with status code: ${response.statusCode}');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Gagal menghubungi server, silakan coba lagi!"))
                        );
                      }
                    }
                  },
                  child: const Text(
                    "Simpan Perubahan",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}