import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  List<String> _books = [];

  @override
  void initState() {
    super.initState();
    fetchGenres();
  }

  void fetchGenres() async {
    var url = Uri.parse('http://localhost:8000/recommendation/get_genres/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        _genres = List<String>.from(json.decode(response.body));
      });
    }
  }

  void fetchBooks(String genre) async {
    var url = Uri.parse('http://localhost:8000/recommendation/get_books_by_genre/$genre/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> booksData = json.decode(response.body);
      setState(() {
        _books = booksData.map((book) => book['nama_buku'] as String).toList();
        _selectedBook = null; // Reset judul buku yang dipilih
      });
    }
  }

  Future<void> submitRecommendation() async {
    if (_formKey.currentState!.validate()) {
      var data = {
        'judul_buku': _judulBukuController.text,
        'nilai_buku': _nilaiBukuController.text,
        'isi_rekomendasi': _isiRekomendasiController.text,
        'genre_buku': _selectedGenre,
      };

      var response = await http.post(
        Uri.parse('http://localhost:8000/recommendation/bikin_flutter/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recommendation submitted successfully'))
          
        );
        
        Navigator.pop(context);
        
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit recommendation'))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommendation Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
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
                validator: (value) => value == null ? 'Please select a genre' : null,
                decoration: InputDecoration(labelText: 'Genre'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedBook,
                onChanged: (newValue) {
                  setState(() {
                    _selectedBook = newValue;
                    _judulBukuController.text = newValue ?? '';
                  });
                },
                items: _books.map<DropdownMenuItem<String>>((String bookTitle) {
                  return DropdownMenuItem<String>(
                    value: bookTitle,
                    child: Text(bookTitle),
                  );
                }).toList(),
                validator: (value) => value == null ? 'Please select a book' : null,
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
                  if (double.tryParse(value) == null || double.parse(value) < 0 || double.parse(value) > 5) {
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
                onPressed: submitRecommendation,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}