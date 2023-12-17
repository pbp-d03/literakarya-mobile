import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:literakarya_mobile/homepage/drawer.dart';
import 'package:literakarya_mobile/user_profile/screens/profile_page.dart';
import 'dart:convert';

import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProfileFormPage extends StatefulWidget {
  const ProfileFormPage({super.key});

  @override
  State<ProfileFormPage> createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = "";
  String _lastName = "";
  String _bio = "";
  String _address = "";
  String _favoriteGenre1 = "";
  String _favoriteGenre2 = "";
  String _favoriteGenre3 = "";
  List<String> _bookGenres = [];

  @override
  void initState() {
    super.initState();
    _fetchBookGenres();
  }

  Future<void> _fetchBookGenres() async {
    final url = 'https://literakarya-d03-tk.pbp.cs.ui.ac.id/books/api/';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> books = json.decode(response.body);
        setState(() {
          Set<String> uniqueBookGenres = Set<String>();
          for (var i = 1; i <= 5; i++) {
            uniqueBookGenres.addAll(books.map((book) => book['fields']['genre_$i'].toString()));
          }
          _bookGenres = uniqueBookGenres.toList()..sort();
        });
      } else {
        print('Failed to load book genres with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to load book genres with error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Buat Profile',
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
                  hintText: "First name",
                  labelText: "First name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _firstName = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "First name tidak boleh kosong!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Last name",
                  labelText: "Last name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _lastName = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Last name tidak boleh kosong!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Bio",
                  labelText: "Bio",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _bio = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Bio tidak boleh kosong!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Address",
                  labelText: "Address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _address = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Address tidak boleh kosong!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: _favoriteGenre1.isEmpty ? null : _favoriteGenre1,
                decoration: InputDecoration(
                  labelText: "Favorite genre 1",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                items: _bookGenres.isEmpty
                    ? [DropdownMenuItem<String>(value: null, child: Text('Favorite genre 1'))]
                    : _bookGenres.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _favoriteGenre1 = newValue ?? '';
                    //_judulBuku = newValue ?? '';
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Genre tidak boleh kosong!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: _favoriteGenre2.isEmpty ? null : _favoriteGenre2,
                decoration: InputDecoration(
                  labelText: "Favorite genre 2",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                items: _bookGenres.isEmpty
                    ? [DropdownMenuItem<String>(value: null, child: Text('Favorite genre 2'))]
                    : _bookGenres.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _favoriteGenre2 = newValue ?? '';
                    //_judulBuku = newValue ?? '';
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Genre tidak boleh kosong!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: _favoriteGenre3.isEmpty ? null : _favoriteGenre3,
                decoration: InputDecoration(
                  labelText: "Favorite genre 3",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                items: _bookGenres.isEmpty
                    ? [DropdownMenuItem<String>(value: null, child: Text('Favorite genre 3'))]
                    : _bookGenres.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _favoriteGenre3 = newValue ?? '';
                    //_judulBuku = newValue ?? '';
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Genre tidak boleh kosong!";
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
                      try {
                      final response = await request.postJson(
                          "https://literakarya-d03-tk.pbp.cs.ui.ac.id/user_profile/create-profile-flutter/",
                          jsonEncode(<String, String>{
                            'first_name' : _firstName,
                            'last_name' : _lastName,
                            'bio' : _bio,
                            'address' : _address,
                            'favorite_genre1' : _favoriteGenre1,
                            'favorite_genre2' : _favoriteGenre2,
                            'favorite_genre3' : _favoriteGenre3,
                          }));
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Profile Anda berhasil disimpan."),
                        ));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfilePage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Gagal, silakan coba lagi!"),
                        ));
                      } 
                      }catch (e) {
                        print('Exception during add: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("An error occurred, please try again."))
                        );
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