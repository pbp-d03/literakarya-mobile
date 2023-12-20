import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:literakarya_mobile/authentication/login.dart';
import 'package:literakarya_mobile/notes/models/note.dart';
import 'package:literakarya_mobile/homepage/drawer.dart';
import 'package:literakarya_mobile/notes/screens/detail_notes.dart';
import 'package:literakarya_mobile/notes/screens/form_notes.dart';
import 'package:literakarya_mobile/notes/screens/edit_notes.dart'; 
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
      if (response.statusCode == 204) {
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

  void refreshNotesList() {
    fetchNote(Provider.of<CookieRequest>(context, listen: false));
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final uname = LoginPage.uname;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal.shade400,
        foregroundColor: Colors.white,
      ),
      drawer: buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.teal),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NoteFormPage()),
                  );
                },
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.teal),
                      SizedBox(width: 8),
                      Text(
                        'Tambah Catatan',
                        style: TextStyle(
                          color: Colors.teal.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            notes.isEmpty
              ? const Center(
                  child: Text(
                    "Tidak ada catatan.",
                    style: TextStyle(color: Color.fromARGB(255, 38, 166, 154), fontSize: 20),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: notes.length,
                  itemBuilder: (_, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailNotePage(item: notes[index])),
                        );
                      },
                      child: Card(
                        color: Colors.teal.shade50,
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                                    style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Text("Judul Buku : ${notes[index].fields.judulBuku}"),
                                  const SizedBox(height: 10),
                                  Text("Isi Catatan : ${notes[index].fields.isiCatatan}"),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Penanda : ${notes[index].fields.penanda}",
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 16, 131, 120)),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (uname != "adminliterakarya")
                                    IconButton(
                                      icon: Icon(Icons.edit, color: Color.fromARGB(255, 38, 166, 154)),
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => EditNotePage(note: notes[index])),
                                        );
                                        if (result == true) {
                                          refreshNotesList();
                                        }
                                      },
                                    ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      int idNote = notes[index].pk;
                                      await deleteNote(idNote, request);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}
