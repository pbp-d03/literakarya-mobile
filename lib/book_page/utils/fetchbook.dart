import 'package:http/http.dart' as http;
import 'package:literakarya_mobile/authentication/login.dart';
import 'dart:convert';

import 'package:literakarya_mobile/book_page/model/books.dart';

Future<List<Book>> fetchBook(String genre) async {
  // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
  var url;
  if (genre == "") {
    url = Uri.parse('https://literakarya-d03-tk.pbp.cs.ui.ac.id/books/api/');
  } else {
    url = Uri.parse(
        'https://literakarya-d03-tk.pbp.cs.ui.ac.id/books/book-filter/$genre/');
  }

  // var url = Uri.parse('https://literakarya-d03-tk.pbp.cs.ui.ac.id/get-items/');
  var response = await http.get(
    url,
    // "Access-Control-Allow-Origin": "*",
    headers: {
      "Content-Type": "application/json",
      // "Access-Control-Allow-Origin": "*",
    },
  );
  // print(response.bodyBytes);
  // melakukan decode response menjadi bentuk json
  var data = jsonDecode(utf8.decode(response.bodyBytes));
  // melakukan konversi data json menjadi object Item
  List<Book> list_book = [];
  // print(data);
  for (var d in data) {
    if (d != null) {
      list_book.add(Book.fromJson(d));
    }
  }
  return list_book;
}
