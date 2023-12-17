import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:literakarya_mobile/authentication/login.dart';
import 'package:literakarya_mobile/forum/models/post.dart';
import 'package:literakarya_mobile/forum/models/reply.dart';
import 'package:literakarya_mobile/forum/screens/forum.dart';
import 'package:literakarya_mobile/homepage/drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class DetailPostPage extends StatefulWidget {
  final Post item;

  DetailPostPage({required this.item});

  @override
  _DetailPostPageState createState() => _DetailPostPageState();
}
class _DetailPostPageState extends State<DetailPostPage> {
  String _body = "";
  final _formKey = GlobalKey<FormState>();
  Future<List<Reply>> fetchReply() async {
    var url = Uri.parse(
        'https://literakarya-d03-tk.pbp.cs.ui.ac.id/forum/json/all-replies/${widget.item.pk}');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Reply> list_reply = [];
    for (var d in data) {
      if (d != null) {
        list_reply.add(Reply.fromJson(d));
      }
    }
    return list_reply.toList();
  }

  Future<void> deleteReply(int replyId, CookieRequest request) async {
      final Uri url = Uri.parse('https://literakarya-d03-tk.pbp.cs.ui.ac.id/forum/delete-reply-flutter/$replyId/');
      final response = await http.delete(url);
      if (response.statusCode == 204) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailPostPage(item:widget.item)),
        );
      } else {
        print('Failed to delete reply, status code: ${response.statusCode}');
      }
    }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum'),
      ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.greenAccent, Colors.blueGrey]
            ),
            borderRadius: BorderRadius.circular(0),
            boxShadow: const [
              BoxShadow(color: Colors.black, blurRadius: 2.0)
            ]
          ),
          child: Center(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        "Balasan untuk post: ${widget.item.fields.subject}",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0,),
                      ),

                      const SizedBox(height: 10),
                      Text(
                        widget.item.fields.topic == "Pilih Judul Buku" ? "Literasi Umum" : widget.item.fields.topic,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5), // Set the opacity value here
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(widget.item.fields.message),
                      const SizedBox(height: 10),
                      Text(
                        widget.item.fields.user + " · " + widget.item.fields.date,
                        style: TextStyle(fontSize: 12),
                      ),                                                                                                              
                    ],
                  ),                
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 9, 13, 93), // Set the color to orange
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Ketik balasan disini...',
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            ),
                            errorStyle: TextStyle(color: Colors.white),
                          ),
                          style: TextStyle(color: Colors.white),
                          onChanged: (String? value) {
                            setState(() {
                              _body = value!;
                            });
                          },
                          onSaved: (String? value) {
                            setState(() {
                              _body = value!;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Balasan masih kosong!";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () async {                            
                              if (_formKey.currentState!.validate()) {

                                final response = await request.postJson(
                                    "https://literakarya-d03-tk.pbp.cs.ui.ac.id/forum/create-reply-flutter/",
                                    jsonEncode(<String, String>{
                                      'post_id' : widget.item.pk.toString(),
                                      'body': _body,
                                    }));
                                if (response['status'] == 'success') {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Pesan Anda berhasil diunggah."),
                                  ));
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => DetailPostPage(item:widget.item)),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Gagal, silakan coba lagi!"),
                                  ));
                                }
                              }
                            },
                            child: Text('Kirim'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: fetchReply(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        if (!snapshot.hasData) {
                          return const Column(
                            children: [
                              Text(
                                "Belum ada balasan.",
                                style: TextStyle(
                                    color: Color(0xff59A5D8), fontSize: 20),
                              ),
                              SizedBox(height: 8),
                            ],
                          );
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (_, index) => InkWell(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${snapshot.data![index].fields.user}",
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (LoginPage.uname == snapshot.data![index].fields.user)
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () async {
                                              int idReply = snapshot.data![index].pk;
                                              await deleteReply(idReply, request);
                                            },
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text("${snapshot.data![index].fields.body}"),
                                    const SizedBox(height: 10),
                                    Text("${snapshot.data![index].fields.date}", style: TextStyle(fontSize: 12),),                                                                        
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      }
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}