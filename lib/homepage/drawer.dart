import 'package:flutter/material.dart';
import 'package:literakarya_mobile/authentication/login.dart';
import 'package:literakarya_mobile/book_page/screen/list_bookmark.dart';
import 'package:literakarya_mobile/book_page/screen/list_buku.dart';
import 'package:literakarya_mobile/ereading/screens/admin_dashboard.dart';
import 'package:literakarya_mobile/ereading/screens/dashboard.dart';
import 'package:literakarya_mobile/recommendation/screens/recommend.dart';
import 'package:literakarya_mobile/user_profile/screens/all_account.dart';
import 'package:literakarya_mobile/user_profile/screens/profile_page.dart';
import 'package:literakarya_mobile/homepage/homepage.dart';
import 'package:literakarya_mobile/notes/screens/list_notes.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:literakarya_mobile/forum/screens/forum.dart';

// merupakan sebuah Drawer yang digunakan untuk navigasi antar page
Drawer buildDrawer(BuildContext context) {
  final request = context.watch<CookieRequest>();
  return Drawer(
    child: Container(
    color: Colors.teal.shade600,
    child: ListView(
      padding: const EdgeInsets.only(top: 60.0, left: 30.0),
      // menu navigasi
      children: [
        ListTile(
          title: const Text('Dashboard', style: TextStyle(color: Colors.yellow)),
          leading: const Icon(Icons.house, color: Colors.yellow),
          onTap: () {
            // Route menu ke counter
            Navigator.pushReplacement(
              context,
              MaterialPageRoute( builder: (context) => const MyHomePage(
              )),
            );
          },
        ),
        Divider(color: Colors.white),
        ListTile(
          title: const Text('My Books', style: TextStyle(color: Colors.white)),
          leading: const Icon(Icons.bookmark_add, color: Colors.white),
          onTap: () {
            // Route menu ke counter
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DaftarBookmark()),
            );
          },
        ),
        // Divider(color: Colors.white),
        ListTile(
          title: const Text('List Buku', style: TextStyle(color: Colors.white)),
          leading: const Icon(Icons.book_sharp, color: Colors.white),
          onTap: () {
            // Route menu ke counter
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DaftarBuku()),
            );
          },
        ),
        ListTile(
          title: const Text('Profile', style: TextStyle(color: Colors.white)),
          leading: const Icon(Icons.account_circle, color: Colors.white),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage.uname == "adminliterakarya"
                  ? const AllAccountPage() 
                  : const ProfilePage()),
            );
          },
        ),
        ListTile(
          title: const Text('Ereading', style: TextStyle(color: Colors.white)),
          leading: const Icon(Icons.bookmarks_rounded, color: Colors.white),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginPage.uname == "adminliterakarya"
                      ? const EreadingAdminPage()
                      : const EreadingUserPage()),
            );
          },
        ),
        ListTile(
          title: const Text('Catatan Saya', style: TextStyle(color: Colors.white)),
          leading: const Icon(Icons.note, color: Colors.white),
          onTap: () {
            // Route menu ke counter
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const NotesPage()));
          }
        ),
        ListTile(
          title: const Text('Rekomendasi', style: TextStyle(color: Colors.white)),
          leading: const Icon(Icons.star, color: Colors.white),
          onTap: () {
            // Route menu ke counter
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RecommendationsPage()));
          }
        ),
        ListTile(
          title: const Text('Forum', style: TextStyle(color: Colors.white)),
          leading: const Icon(Icons.groups, color: Colors.white),
          onTap: () {
            // Route menu ke counter
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ForumPage()));
          }
        )
      ],
    ),
  ));
}
