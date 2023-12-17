import 'package:flutter/material.dart';
import 'package:literakarya_mobile/authentication/login.dart';
import 'package:literakarya_mobile/homepage/drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:literakarya_mobile/user_profile/models/profile.dart';
import 'package:literakarya_mobile/user_profile/screens/edit_profile.dart';
import 'package:literakarya_mobile/user_profile/screens/profile_form.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Profile> profiles = [];

  Future<void> fetchProfile(request) async {
    try {
      var data = await request.get('https://literakarya-d03-tk.pbp.cs.ui.ac.id/user_profile/json/');
      List<Profile> listProfile = [];
      for (var d in data) {
        if (d != null) {
          listProfile.add(Profile.fromJson(d));
        }
      }
      setState(() {
        profiles = listProfile;
      });
    } catch (e) {
      print('Error fetching profiles: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchProfile(Provider.of<CookieRequest>(context, listen: false));
    });
  }

  void refreshProfileList() {
    fetchProfile(Provider.of<CookieRequest>(context, listen: false));
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final uname = LoginPage.uname;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
        ),
        backgroundColor: Colors.teal.shade400,
        foregroundColor: Colors.white,
      ),
      drawer: buildDrawer(context),
      body: Center(
        child: ListView.builder(
                itemCount: profiles.length,
                itemBuilder: (_, index) => Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 200.0,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 14.0),
                      Text(
                        "$uname Profile",
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Full Name: ${profiles[index].fields.firstName} ${profiles[index].fields.lastName}",
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Color.fromARGB(221, 64, 64, 64),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Bio: ${profiles[index].fields.bio}",
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Color.fromARGB(221, 64, 64, 64),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Address: ${profiles[index].fields.address}",
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Color.fromARGB(221, 64, 64, 64),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Favorite Genres: ${profiles[index].fields.favoriteGenre1}, ${profiles[index].fields.favoriteGenre2}, ${profiles[index].fields.favoriteGenre3}",
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Color.fromARGB(221, 64, 64, 64),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Edit Profile Button
                      ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilePage(profile: profiles[index]),
                            ),
                          );
                          if (result == true) {
                            refreshProfileList();
                          }
                        },
                        child: Text('Edit Profile'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
