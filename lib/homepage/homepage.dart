import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:literakarya_mobile/authentication/login.dart';
import 'package:literakarya_mobile/book_page/screen/list_bookmark.dart';
import 'package:literakarya_mobile/book_page/screen/list_buku.dart';
import 'package:literakarya_mobile/homepage/drawer.dart';
import 'package:literakarya_mobile/recommendation/screens/recommend.dart';
import 'package:literakarya_mobile/user_profile/screens/recommend_byfavgenre.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return MaterialApp(
        theme: ThemeData(
            fontFamily: 'Poppins',
            textTheme: TextTheme(
                bodyText1: TextStyle(fontWeight: FontWeight.w400), // SemiBold
                bodyText2: TextStyle(fontWeight: FontWeight.w400))), // SemiBold
        debugShowCheckedModeBanner: false,
        title: "Dashboard",
        home: Scaffold(
          appBar: AppBar(
            title: Text(
        'Dashboard',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
        ),
      ),
            backgroundColor: Colors.teal,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Image.asset('assets/images/logo_literakarya.png'),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () async {
                  final response = await request.logout(
                      // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                      "https://literakarya-d03-tk.pbp.cs.ui.ac.id/auth/logout/");
                  String message = response["message"];
                  if (response['status']) {
                    String uname = response["username"];
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("$message Sampai jumpa, $uname."),
                    ));
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (Route<dynamic> route) => false);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("$message"),
                    ));
                  }
                },
              ),
            ],
          ),
          drawer: buildDrawer(context),
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildTopImageSection(),
                  _buildWelcomeSection(),
                  _buildDescriptionSection(),
                  _buildBookTitleSection(),
                  _buildImageSection(),
                  _buildViewMoreButton(context),
                  _buildFeatureTitleSection(),
                  _buildFeatureSection(),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildTopImageSection() {
    return Container(
      width: double.infinity, // Lebar kontainer disesuaikan dengan lebar layar
      height:
          350.0, // Tinggi kontainer disetel menjadi 200.0, atau sesuaikan sesuai keinginan
      child: Image.network(
        'https://iili.io/JuajsTv.png',
        fit: BoxFit
            .cover, // Mengatur agar gambar menyesuaikan kontainer tanpa kehilangan proporsi
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Selamat datang di LiteraKarya!',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 28, // Large font size
          fontWeight: FontWeight.bold, // Bold text
          color: Colors.teal.shade700, // Teal color
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Card(
      color: Colors.teal.shade100,
      margin: const EdgeInsets.all(16.0),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'LiteraKarya adalah platform informasi buku online yang memadukan kemudahan akses ke berbagai buku digital untuk meningkatkan semangat membaca. Dalam upaya memperluas wawasan literasi, LiteraKarya menawarkan berbagai informasi tentang buku, termasuk karya-karya baik dari penulis dalam negeri maupun luar negeri.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black, // Black color
            fontFamily: 'Poppins', 
            fontWeight: FontWeight.w700,
            textBaseline: TextBaseline.alphabetic,
          ),
          textAlign: TextAlign.justify, // Justified alignment
        ),
      ),
    );
  }

  Widget _buildBookTitleSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Lihat Buku',
        style: TextStyle(   
          fontFamily: 'Poppins',     
          fontSize: 30, // Large font size
          fontWeight: FontWeight.bold, // Bold text
          color: Colors.teal.shade700, // Teal color
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 300, // Set a fixed height for the horizontal list
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // Set the number of items in the list to 5
        itemBuilder: (context, index) {
          // Define the image URLs, titles, authors, and ratings based on the index
          List<String> imageUrls = [
            'assets/images/bumimanusia.png',
            'assets/images/perahukertas.png',
            'assets/images/ayatayatcinta.png',
            'assets/images/thecityofember.png',
            'assets/images/thehobbit.png'
          ];

          List<String> titles = [
            'Bumi Manusia',
            'Perahu Kertas',
            'Ayat-Ayat Cinta',
            'The City of Ember',
            'The Hobbit',
          ];

          List<String> authors = [
            'Pramoedya A. Noer',
            'Dee Lestari',
            'H. El-Shirazy',
            'Jeanner DuPrau',
            'J.R.R. Tolkien'
          ];

          List<String> ratings = ['4.41/5', '3.99/5', '3.88/5', '3.89/5', '4.28/5'];

          return _buildImageDetail(
              imageUrls[index], titles[index], authors[index], ratings[index]);
        },
      ),
    );
  }

  Widget _buildViewMoreButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const DaftarBuku()),
          );
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.teal,
          onPrimary: Colors.white,
          padding: EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0), // More rounded corners
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Lihat Selengkapnya', style: TextStyle(fontSize: 14)),
            Icon(Icons.arrow_forward_ios_rounded, size: 18),
          ],
        ),
      ),
    );
  }


  Widget _buildImageDetail(
      String imageUrl, String title, String author, String rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Center(
        // Center widget to center the contents
        child: Column(
          mainAxisSize:
              MainAxisSize.max, // Make the column take up all available space
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the contents vertically
          children: <Widget>[
            Image.asset(
              imageUrl,
              width: 160, // Adjust the image width
              height: 200, // Adjust the image height
            ),
            Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('Author: $author', style: TextStyle(fontSize: 14)),
            Text('Rating: $rating', style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTitleSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Fitur LiteraKarya',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 30, // Large font size
          fontWeight: FontWeight.bold, // Bold text
          color: Colors.teal.shade700, // Teal color
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildFeatureSection() {
    List<Map<String, dynamic>> features = [
      {
        'title': 'Buku Saya',
        'description':
            'Buku-buku pilihan yang ingin dibaca kemudian hari dapat ditandai dulu di fitur ini.',
        'color': Colors.green.shade100
      },
      {
        'title': 'Daftar Buku',
        'description':
            'Menampilkan daftar dari berbagai buku bacaan dalam negeri maupun luar negeri, lengkap dengan detail dari masing-masing buku dan fitur searchbar.',
        'color': Color.fromARGB(255, 255, 239, 205)
      },
      {
        'title': 'Personalisasi',
        'description':
            'Isi profilmu dan dapatkan rekomendasi buku dari kami.',
        'color': Colors.blue.shade100
      },
            {
        'title': 'Ereading',
        'description':
            'Tambahkan koleksi bacaan digital milikmu dengan fitur Ereading.',
        'color': Colors.yellow.shade100
      },
      {
        'title': 'Catatan',
        'description':
            'Buat catatanmu untuk mengingat berbagai informasi terkait bacaan.',
        'color': Colors.orange.shade100
      },
      {
        'title': 'Rekomendasi',
        'description':
            'Berbagi dan dapatkan rekomendasi-rekomendasi buku pilihan yang ada untuk dapat Anda baca dan nikmati segera.',
        'color': const Color.fromARGB(255, 255, 209, 225)
      },
      {
        'title': 'Forum',
        'description':
            'Berinteraksi dengan pengguna lainnya di dalam Forum. Komunitas kami penuh semangat untuk berdiskusi tentang berbagai judul buku maupun topik literasi umum.',
        'color': const Color.fromARGB(255, 246, 223, 250)
      },
    ];

    return ListView.builder(
      itemCount: features.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        return _buildCard(features[index]['title']!,
            features[index]['description']!, features[index]['color']);
      },
    );
  }

  Widget _buildCard(String title, String description, Color color) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.5), // Adjust the opacity as needed
          blurRadius: 4.0, // Adjust blur radius
          spreadRadius: 1.0, // Adjust spread radius
          offset: Offset(0, 2), // Adjust the offset
        ),
      ],
    ),
    child: Card(
      color: color,
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ),
  );
}

}