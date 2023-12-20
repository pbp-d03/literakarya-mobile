import 'package:flutter/material.dart';
import 'package:literakarya_mobile/authentication/login.dart';
import 'package:literakarya_mobile/homepage/drawer.dart';
import 'package:literakarya_mobile/user_profile/models/profile.dart';
import 'package:literakarya_mobile/user_profile/screens/edit_profile.dart';
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
    final uname = LoginPage.uname;
    return Scaffold(
      appBar: AppBar(
      title: Text(
        'Profil',
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
        drawer: buildDrawer(context),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/listbook.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.85), // Atur opasitas di sini (0.1 untuk 10% opacity)
                  BlendMode.dstATop, // Mode campuran yang digunakan
                ),),
              ),
            ),
            Center(
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
                    ClipOval(
                        child: Image.asset(
                          'assets/images/profile.png', // Path to your image asset
                          width: 200.0, // Adjust the width as needed (should be equal to height for a perfect circle)
                          height: 200.0, // Adjust the height as needed
                          fit: BoxFit.cover, // Adjust the fit as needed
                        ),
                      ),
                      const SizedBox(height: 14.0),
                     Stack(
                      children: [
                        // Teks dengan border
                        Text(
                          "$uname Profile",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 5 // Lebar border hitam
                              ..color = Color.fromARGB(255, 61, 109, 121), // Warna border hitam
                          ),
                        ),
                        // Teks utama
                        Text(
                          "$uname Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontFamily: 'Sansita',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 61, 109, 121),
                              blurRadius: 4.0,
                              spreadRadius: 1.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Full Name: ${profiles[index].fields.firstName} ${profiles[index].fields.lastName}",
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Bio: ${profiles[index].fields.bio}",
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Address: ${profiles[index].fields.address}",
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Favorite Genres: ${profiles[index].fields.favoriteGenre1}, ${profiles[index].fields.favoriteGenre2}, ${profiles[index].fields.favoriteGenre3}",
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Edit Profile Button
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.teal.shade400),
                          elevation: MaterialStateProperty.all(4),
                        ),
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
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(color: Colors.white),
                          ),
                        
                      ),
                    ],
                  ),
                ),
                ),
                ),
    ],
    ),
            );   
  }
}
