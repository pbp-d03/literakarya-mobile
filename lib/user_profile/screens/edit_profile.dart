import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:literakarya_mobile/homepage/drawer.dart';
import 'dart:convert';

import 'package:literakarya_mobile/user_profile/models/profile.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  final Profile profile;
  const EditProfilePage({Key? key, required this.profile}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late String _firstName;
  late String _lastName;
  late String _bio;
  late String _address;
  late String _favoriteGenre1;
  late String _favoriteGenre2;
  late String _favoriteGenre3;
  List<String> _bookGenres = [];

  @override
  void initState() {
    super.initState();
    _fetchBookGenres();
    _initializeFormData();
  }

  void _initializeFormData() {
    _firstName = widget.profile.fields.firstName;
    _lastName = widget.profile.fields.lastName;
    _bio = widget.profile.fields.bio;
    _address = widget.profile.fields.address;
    _favoriteGenre1 = widget.profile.fields.favoriteGenre1;
    _favoriteGenre2 = widget.profile.fields.favoriteGenre2;
    _favoriteGenre3 = widget.profile.fields.favoriteGenre3;
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
    int id = widget.profile.pk;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Edit Profile',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 38, 166, 154),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: _firstName,
                decoration: InputDecoration(
                  hintText: "First name",
                  labelText: "First name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) => _firstName = value,
                validator: (value) {
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
                initialValue: _lastName,
                decoration: InputDecoration(
                  hintText: "Last name",
                  labelText: "Last name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) => _lastName = value,
                validator: (value) {
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
                initialValue: _bio,
                decoration: InputDecoration(
                  hintText: "Bio",
                  labelText: "Bio",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) => _bio = value,
                validator: (value) {
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
                initialValue: _address,
                decoration: InputDecoration(
                  hintText: "Address",
                  labelText: "Address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) => _address = value,
                validator: (value) {
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
                value: _favoriteGenre1,
                decoration: InputDecoration(
                  labelText: "Favorite genre 1",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                items: _bookGenres.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _favoriteGenre1 = newValue!;
                  });
                },
                validator: (value) {
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
                value: _favoriteGenre2,
                decoration: InputDecoration(
                  labelText: "Favorite genre 2",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                items: _bookGenres.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _favoriteGenre2 = newValue!;
                  });
                },
                validator: (value) {
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
                value: _favoriteGenre3,
                decoration: InputDecoration(
                  labelText: "Favorite genre 3",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                items: _bookGenres.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _favoriteGenre3 = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Genre tidak boleh kosong!";
                  }
                  return null;
                },
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextFormField(
            //     initialValue: _favoriteGenre1,
            //     decoration: InputDecoration(
            //       hintText: "Favorite genre 1",
            //       labelText: "Favorite genre 1",
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(5.0),
            //       ),
            //     ),
            //     onChanged: (value) => _favoriteGenre1 = value,
            //     validator: (value) {
            //       if (value == null || value.isEmpty) {
            //         return "Favorite genre 1 tidak boleh kosong!";
            //       }
            //       return null;
            //     },
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextFormField(
            //     initialValue: _favoriteGenre2,
            //     decoration: InputDecoration(
            //       hintText: "Favorite genre 2",
            //       labelText: "Favorite genre 2",
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(5.0),
            //       ),
            //     ),
            //     onChanged: (value) => _favoriteGenre2 = value,
            //     validator: (value) {
            //       if (value == null || value.isEmpty) {
            //         return "Favorite genre 2 tidak boleh kosong!";
            //       }
            //       return null;
            //     },
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextFormField(
            //     initialValue: _favoriteGenre3,
            //     decoration: InputDecoration(
            //       hintText: "Favorite genre 3",
            //       labelText: "Favorite genre 3",
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(5.0),
            //       ),
            //     ),
            //     onChanged: (value) => _favoriteGenre3 = value,
            //     validator: (value) {
            //       if (value == null || value.isEmpty) {
            //         return "Favorite genre 3 tidak boleh kosong!";
            //       }
            //       return null;
            //     },
            //   ),
            // ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.teal.shade400),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final response = await request.postJson(
                          "https://literakarya-d03-tk.pbp.cs.ui.ac.id/user_profile/edit-profile-flutter/$id/",
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Profile Anda berhasil diperbarui."))
                          );
                          // Trigger a state refresh or navigate to the updated list
                          Navigator.pop(context, true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Gagal, silakan coba lagi!"))
                          );
                        }
                      } catch (e) {
                        print('Exception during update: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("An error occurred, please try again."))
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