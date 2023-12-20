import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:literakarya_mobile/recommendation/screens/recommend.dart';
import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class FormRecommend extends StatefulWidget {
  @override
  _FormRecommendState createState() => _FormRecommendState();
}

class _FormRecommendState extends State<FormRecommend> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _judulBukuController = TextEditingController();
  TextEditingController _nilaiBukuController = TextEditingController();
  TextEditingController _isiRekomendasiController = TextEditingController();
  String? _selectedGenre;
  String? _selectedBook;
  List<String> _genres = [];
  List<Map<String, dynamic>> _books = [];


  @override
  void initState() {
    super.initState();
    fetchGenres();
  }

  void fetchGenres() async {
    var url = Uri.parse('https://literakarya-d03-tk.pbp.cs.ui.ac.id/recommendation/get_genres/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        _genres = List<String>.from(json.decode(response.body));
      });
    }
  }

  void fetchBooks(String genre) async {
    var url = Uri.parse('https://literakarya-d03-tk.pbp.cs.ui.ac.id/recommendation/get_books_by_genre/$genre/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        _books = List<Map<String, dynamic>>.from(json.decode(response.body));
        _selectedBook = null; // Reset pilihan judul buku
      });
    }
  }

  
  Future<void> submitRecommendation() async {
  if (_formKey.currentState!.validate()) {
    // Mengumpulkan data dari form
    String genreBuku = _selectedGenre ?? '';
    String judulBukuId = _selectedBook ?? '';
    String nilaiBuku = _nilaiBukuController.text;
    String isiRekomendasi = _isiRekomendasiController.text;

    // Membuat request POST ke server Django
    final request = context.read<CookieRequest>();
    final response = await request.postJson(
      "https://literakarya-d03-tk.pbp.cs.ui.ac.id/recommendation/bikin_flutter/",
      jsonEncode({
        'genre_buku': genreBuku,
        'judul_buku': judulBukuId, // Pastikan ini adalah ID buku
        'nilai_buku': nilaiBuku,
        'isi_rekomendasi': isiRekomendasi,
      }),
    );

    // Menangani respons dari server
    if (response["status"] == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recommendation submitted successfully'))
      );

      Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RecommendationsPage()));

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit recommendation'))
      );
    }
  }
}


  @override
Widget build(BuildContext context) {
  final request = context.watch<CookieRequest>();

  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Rekomendasi Form',
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
    body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/recommendation.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Give Us Some Book Recommendation!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                // Sisipkan widget formulir Anda di sini
                DropdownButtonFormField<String>(
                value: _selectedGenre,
                onChanged: (newValue) {
                  setState(() {
                    _selectedGenre = newValue;
                    fetchBooks(newValue!);
                  });
                },
                items: _genres.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Please select a genre' : null,
                decoration: InputDecoration(labelText: 'Genre'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedBook,
                onChanged: (newValue) {
                  setState(() {
                    _selectedBook = newValue;
                  });
                },
                items: _books.map<DropdownMenuItem<String>>((Map<String, dynamic> book) {
                  return DropdownMenuItem<String>(
                    value: book['id'].toString(), // Gunakan ID buku sebagai value
                    child: Text(book['nama_buku']), // Tampilkan nama buku
                  );
                }).toList(),
                  validator: (value) =>
                      value == null ? 'Please select a book' : null,
                  decoration: InputDecoration(labelText: 'Book Title'),
              ),
              TextFormField(
                controller: _nilaiBukuController,
                decoration: InputDecoration(labelText: 'Rating (0-5)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a rating';
                  }
                  if (double.tryParse(value) == null ||
                      double.parse(value) < 0 ||
                      double.parse(value) > 5) {
                    return 'Please enter a valid rating between 0 and 5';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _isiRekomendasiController,
                decoration: InputDecoration(labelText: 'Recommendation'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your recommendation';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () => submitRecommendation(),
                child: Text('Submit'),
              ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

}
