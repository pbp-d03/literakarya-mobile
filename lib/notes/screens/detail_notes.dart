import 'package:flutter/material.dart';
import 'package:literakarya_mobile/notes/models/note.dart';

class DetailNotePage extends StatelessWidget {
  final Note item;

  DetailNotePage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(
        item.fields.judulCatatan,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
        ),
      ),
        backgroundColor: Colors.teal.shade400,
        foregroundColor: Colors.white,
    ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.teal.shade50,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.fields.judulCatatan,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(color: Colors.black), // Divider berwarna hitam
                const SizedBox(height: 10),
                Text("Judul Buku: ${item.fields.judulBuku}"),
                const SizedBox(height: 10),
                Text("Isi Catatan: ${item.fields.isiCatatan}"),
                const SizedBox(height: 10),
                Text("Penanda: ${item.fields.penanda}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
