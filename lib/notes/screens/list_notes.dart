import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literakarya_mobile/notes/models/note.dart';
import 'package:literakarya_mobile/homepage/drawer.dart';
import 'package:literakarya_mobile/notes/screens/detail_notes.dart';
import 'package:literakarya_mobile/notes/screens/form_notes.dart';
import 'package:literakarya_mobile/notes/screens/edit_notes.dart'; // Import your edit page
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
 import 'package:http/http.dart' as http;

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key});

  @override
  State<StatefulWidget> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> notes = [];

  Future<void> fetchNote(request) async {
    try {
      var data = await request.get('https://literakarya-d03-tk.pbp.cs.ui.ac.id/notes/get-note/');
      List<Note> listNote = [];
      for (var d in data) {
        if (d != null) {
          listNote.add(Note.fromJson(d));
        }
      }
      setState(() {
        notes = listNote;
      });
    } catch (e) {
      print('Error fetching notes: $e');
    }
  }

  Future<void> deleteNote(int noteId, CookieRequest request) async {
    try {
      final Uri url = Uri.parse('https://literakarya-d03-tk.pbp.cs.ui.ac.id/notes/delete-note-flutter/$noteId/');
      final response = await http.delete(url);
      if (response.statusCode == 204) { // Assuming 204 is used for successful deletion
        print('Note deleted successfully');
        setState(() {
          notes.removeWhere((note) => note.pk == noteId);
        });
      } else {
        print('Failed to delete note, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting note: $e');
    }
  }



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchNote(Provider.of<CookieRequest>(context, listen: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Catatan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NoteFormPage(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: buildDrawer(context),
      body: notes.isEmpty
          ? const Center(
              child: Text(
                "Tidak ada catatan.",
                style: TextStyle(color: Color.fromARGB(255, 43, 18, 201), fontSize: 20),
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (_, index) => InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailNotePage(item: notes[index]),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${notes[index].fields.judulCatatan}",
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text("Judul Buku : ${notes[index].fields.judulBuku}"),
                            const SizedBox(height: 10),
                            Text("Isi Catatan : ${notes[index].fields.isiCatatan}"),
                            const SizedBox(height: 10),
                             Text(
                              "Penanda : ${notes[index].fields.penanda}",
                              style: const TextStyle(
                                color:   Color.fromARGB(255, 41, 98, 255), // Warna biru tua
                              ))
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditNotePage(note: notes[index]),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                              int idNote = notes[index].pk;
                            final response = await request.postJson(
                                "https://literakarya-d03-tk.pbp.cs.ui.ac.id/notes/delete-note-flutter/$idNote/",
                                jsonEncode(<String, String>{
                                }));
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
