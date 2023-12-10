import 'package:http/http.dart' as http;
import 'package:literakarya_mobile/authentication/login.dart';
import 'dart:convert';

import 'package:literakarya_mobile/book_page/model/books.dart';
import 'package:literakarya_mobile/book_page/model/comment.dart';

Future<List<Komen>> fetchKomen(int id) async {
  // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
  var url = Uri.parse(
      'https://literakarya-d03-tk.pbp.cs.ui.ac.id/books/get-komen/$id/');
  // var url = Uri.parse('http://localhost:8000/get-items/');
  var response = await http.get(
    url,
    // "Access-Control-Allow-Origin": "*",
    headers: {
      "Content-Type": "application/json",
      // "Access-Control-Allow-Origin": "*",
    },
  );
  // print(response.body);
  // melakukan decode response menjadi bentuk json
  var data = jsonDecode(utf8.decode(response.bodyBytes));
  // melakukan konversi data json menjadi object Item
  List<Komen> list_komen = [];
  // print(data);
  for (var d in data) {
    if (d != null) {
      list_komen.add(Komen.fromJson(d));
    }
  }
  return list_komen;
}
