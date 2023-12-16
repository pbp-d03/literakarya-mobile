import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:literakarya_mobile/authentication/login.dart';
import 'package:literakarya_mobile/notes/models/note.dart';
import 'package:literakarya_mobile/homepage/drawer.dart';
import 'package:literakarya_mobile/notes/screens/detail_notes.dart';
import 'package:literakarya_mobile/notes/screens/form_notes.dart';
import 'package:literakarya_mobile/notes/screens/edit_notes.dart'; // Import your edit page
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class DetailPostPage extends StatelessWidget {
  final Note item;

  DetailPostPage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          item.fields.judulCatatan,
          style: TextStyle(color: Colors.white),
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