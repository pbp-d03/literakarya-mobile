// All
import 'package:flutter/material.dart';
import 'package:literakarya_mobile/book_page/screen/list_buku.dart';
import 'package:literakarya_mobile/homepage/drawer.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  // final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forum"),
      ),
      drawer: buildDrawer(context),
      body: Center(
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.greenAccent, Colors.blueGrey]),
                borderRadius: BorderRadius.circular(0),
                boxShadow: const [
                  BoxShadow(color: Colors.black, blurRadius: 2.0)
                ]),
            child: Column(
              children: [
                SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35)),
                  child: Container(
                      padding: EdgeInsets.all(5),
                      // decoration: BoxDecoration(
                      // padding: const EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: Image.network(
                          "https://i.pinimg.com/564x/d1/d8/e5/d1d8e5990a1d4b43ee791be68451d4f7.jpg",
                          height: 240,
                        ),
                      )),
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 6),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "LiteraKarya adalah platform baca buku online yang memadukan kemudahan akses ke berbagai buku digital dengan elemen-elemen gamifikasi untuk meningkatkan semangat membaca. Dalam upaya memperluas wawasan literasi, LiteraKarya menawarkan berbagai informasi tentang buku, termasuk karya-karya dari penulis Indonesia dan luar negeri.",
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 6),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(children: [
                        Text(
                          "Literakarya adalah website list buku yang bagus dan menarik!",
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DaftarBuku()),
                            );
                          },
                          child: Text('See all Books'),
                        )
                      ]),
                    ),
                  ],
                ),
              ],
            )),
        // MULAI KERJAIN DARI SINI YA
      ),
    );
  }
}
