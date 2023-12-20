import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:literakarya_mobile/authentication/login.dart';
import 'package:literakarya_mobile/homepage/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:literakarya_mobile/recommendation/screens/edit_recommend.dart';
import 'package:literakarya_mobile/recommendation/screens/form_recommend.dart';
import 'package:provider/provider.dart';
import 'package:literakarya_mobile/recommendation/models/recommendation.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:audioplayers/audioplayers.dart';



// Assuming you already have the Rekomendasi class defined

// Function to fetch recommendations
Future<List<Rekomendasi>> fetchRecommendations() async {
  final response = await http.get(Uri.parse('https://literakarya-d03-tk.pbp.cs.ui.ac.id/recommendation/json/'));

  if (response.statusCode == 200) {
    return rekomendasiFromJson(response.body);
  } else {
    throw Exception('Failed to load recommendations');
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Litera Karya',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 91, 178, 199),
        hintColor: Color(0xFFF9BE5A),
        fontFamily: 'Poppins',
        textTheme: TextTheme(
          bodyText1: TextStyle(fontWeight: FontWeight.w400), // Regular, not SemiBold
          bodyText2: TextStyle(fontWeight: FontWeight.w400), // Regular, not SemiBold
        ),
        // Define other theme properties if necessary
      ),
      home: RecommendationsPage(),
    );
  }
}

class RecommendationsPage extends StatefulWidget {
  RecommendationsPage({Key? key}) : super(key: key);

  @override
  _RecommendationsPageState createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  late Future<List<Rekomendasi>> futureRecommendations;
  bool showBookRecommendations = true; // Toggle state for showing book recommendations
  late AudioPlayer audioPlayer; // Declare audioPlayer at class level
  bool isPlaying = false; // Declare isPlaying at class level
  Map<int, bool> likesState = {}; // Tracks whether a recommendation is liked
  Map<int, int> totalLikes = {}; // Tracks total likes for each recommendation

  Future<void> deleteRecommendation(int pk) async {
  try {
    final response = await http.delete(
  Uri.parse('https://literakarya-d03-tk.pbp.cs.ui.ac.id/recommendation/hapus_rekom_flutter/$pk/'),
      headers: {
        'Content-Type': 'application/json',
        // Tambahkan header autentikasi jika diperlukan
      },
      body: jsonEncode({'id': pk}),
    );

    if (response.statusCode == 200) {
      // Hapus item dari daftar rekomendasi dan perbarui UI
      setState(() {
        futureRecommendations = fetchRecommendations();
      });
    } else {
      throw Exception('Failed to delete the recommendation');
    }
  } catch (e) {
    // Tampilkan error kepada pengguna atau log error
    print('Error deleting recommendation: $e');
  }
}

  @override
  void initState() {
    super.initState();

    audioPlayer = AudioPlayer();

    futureRecommendations = fetchRecommendations().then((recommendations) async {
    for (var recommendation in recommendations) {
      likesState[recommendation.pk] = recommendation.fields.likes.contains(recommendation.pk);
      totalLikes[recommendation.pk] = recommendation.fields.likes.length;
    }
    return recommendations;
  });
  }

  @override
  void dispose() {
    audioPlayer.dispose(); // Dispose of audioPlayer when widget is disposed
    super.dispose();
  }

void navigateAndRefresh() async {
  await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => FormRecommend()),
  );

  // Refresh the recommendations after returning from the FormRecommend page
  setState(() {
    futureRecommendations = fetchRecommendations();
  });
}

Future<void> onLikeToggle(int pk) async {
  final CookieRequest request = Provider.of<CookieRequest>(context, listen: false);
  bool newLikeStatus = !(likesState[pk] ?? false);

  // Toggle state lokal
  setState(() {
    likesState[pk] = newLikeStatus;
    totalLikes[pk] = (totalLikes[pk] ?? 0) + (newLikeStatus ? 1 : -1);
  });

  try {
    final Uri uri = Uri.parse('https://literakarya-d03-tk.pbp.cs.ui.ac.id/recommendation/like_flutter/$pk/');
    final responseData = await request.post(
      uri.toString(),
      jsonEncode({'action': newLikeStatus ? 'like' : 'unlike', 'user_id': LoginPage.uname}),
    );

    if (responseData['status'] == 'success') {
      setState(() {
        totalLikes[pk] = responseData['total_likes'];
        likesState[pk] = responseData['is_liked'];
      });
      print('Sending User ID: $request');

    } else {
      // Rollback state jika terjadi error
      setState(() {
        likesState[pk] = !newLikeStatus;
        totalLikes[pk] = (totalLikes[pk] ?? 0) + (!newLikeStatus ? 1 : -1);
      });
      print('Error updating like status: ${responseData['message']}');
    }
  } catch (e) {
    // Rollback state jika terjadi error
    setState(() {
      likesState[pk] = !newLikeStatus;
      totalLikes[pk] = (totalLikes[pk] ?? 0) + (!newLikeStatus ? 1 : -1);
    });
    print('Error updating like status: $e');
  }
}



 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Rekomendasi',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
      ),
        backgroundColor: Colors.teal.shade400,
        foregroundColor: Colors.white,
    ),
    drawer: buildDrawer(context),
    body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/recommendation.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          greetingSection(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded( // Gunakan Expanded
                  child: ElevatedButton(
                  onPressed: () => setState(() {
                    showBookRecommendations = true;
                  }),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // To wrap the content of the row
                    children: <Widget>[
                      FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Image.asset(
                          'assets/images/minibook.png', // Ganti dengan nama asset Anda
                          height: 20, // Atur ukuran ini
                          width: 20,
                        ),
                      ),
                      SizedBox(width: 8), // Spacing between the icon and text
                      Flexible(
                      child: Text(
                        'Book Recommendation',
                        style: TextStyle(
                          color: Color.fromARGB(255, 6, 0, 0),
                          fontSize: 12.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: showBookRecommendations ? Color(0xFFF9BE5A) : Color.fromARGB(255, 254, 255, 255),
                    padding: EdgeInsets.symmetric(horizontal: 12), // Add padding if needed
                  ),
                ),),
                SizedBox(width: 8), // Jarak antara tombol
                Expanded( // Gunakan E
                child: ElevatedButton(
                  onPressed: () => setState(() {
                    showBookRecommendations = false;
                  }),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // To wrap the content of the row
                    children: <Widget>[
                      FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Image.asset(
                          'assets/images/gramaphone.png', // Ganti dengan nama asset Anda
                          height: 20, // Atur ukuran ini
                          width: 20,
                        ),
                      ),
                      SizedBox(width: 8), // Spacing between the icon and text
                      Flexible(
                        child: Text(
                        'Music Playlist',
                        style: TextStyle(
                          color: Color.fromARGB(255, 6, 0, 0),
                          fontSize: 12.0,
                          fontFamily: 'Sansita',
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: showBookRecommendations ?Color.fromARGB(255, 254, 255, 255) : Color(0xFFF9BE5A),
                    padding: EdgeInsets.symmetric(horizontal: 12), 
                  ),
                ),
            ),
            ],
            ),
          ),
          Expanded(
            child: showBookRecommendations ? bookRecommendationView() : musicPlaylistView(),
          ),
        ],
      ),
    ),
  );
}


  Widget greetingSection() {
    return Container(
      width: 366,
      height: 143,
      child: Stack(
        children: [
          Positioned(
            left: 9,
            top: 17,
            child: Opacity(
              opacity: 0.90,
              child: Container(
                width: 357,
                height: 126,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 163,
            top: 62,
            child: SizedBox(
              width: 157,
              height: 72,
              child: Text(
                'Ready to explore with Litera Karya?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ),
          ),
          Positioned(
            left: 138,
            top: 40,
            child: SizedBox(
              width: 207,
              height: 23,
              child: Text(
                'Hello, ${LoginPage.uname}!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 143,
              height: 143,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/person.png"), // Change this to your user's image path
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(15), // If you want the image to be rounded
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bookCard(Fields fields, int pk, Rekomendasi recommendation) {
    // bool isCurrentUser = currentUserId == recommendation.userId;
    bool isLiked = likesState[pk] ?? false;
    int currentTotalLikes = totalLikes[pk] ?? 0;
  return Container(
    margin: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Color.fromARGB(255, 61, 109, 121),
          blurRadius: 4.0,
          spreadRadius: 1.0,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      color: Colors.teal.shade400, // Set Card color to white
      child: Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Match the card's border radius
                  child: Image.network(
                    fields.gambarBuku,
                    fit: BoxFit.cover,
                    height: 100, // Fixed height for the image
                    width: double.infinity,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  fields.judulBuku,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  'Genre: ${fields.genreBuku}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  'Rating: ${fields.nilaiBuku}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Review: \n${fields.isiRekomendasi}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey,
                      ),
                      onPressed: () => onLikeToggle(pk),
                    ),
                    Text('$currentTotalLikes likes',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Row(
            children: [
              if (LoginPage.uname == 'adminliterakarya')
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditRecommend(recommendation: recommendation),
                    ),
                  );
                },
              ),
              if (LoginPage.uname == 'adminliterakarya')
              IconButton(
                icon: Icon(Icons.delete, color: Color.fromARGB(255, 255, 255, 255)),
                onPressed: () {
                  deleteRecommendation(pk);
                },
              ),
            ],
          ),
        ),
      ],
    ),
  )
  );
}


  Widget bookRecommendationView() {
    return Column(
      children: [
        // Add Recommendation Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: ElevatedButton(
            onPressed: () {
              // Navigate to the FormRecommend page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormRecommend()),
              );
            },
            child: Text('Add Recommendation'),
            style: ElevatedButton.styleFrom(
              primary: Colors.teal.shade700, // Use your primary color here
              onPrimary: Colors.white, // Text color
            ),
          ),
        ),
        Expanded(
        child: FutureBuilder<List<Rekomendasi>>(
          future: futureRecommendations,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              return GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.6,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var recommendation = snapshot.data![index];
                  return bookCard(recommendation.fields, recommendation.pk, recommendation);
                },
              );
            } else {
              return Center(child: Text("No recommendations found."));
            }
          },
        ),
      ),
    ],
  );
}


  Widget musicPlaylistView() {
  // List of songs
  final List<String> songs = [
    'Compfest', // Assuming this is the title of your first song
    'Song Title 1',
    'Song Title 2',
    'Song Title 3',
    'Song Title 4',
    'Song Title 5',
  ];

  // Corresponding paths to your songs
  final List<String> songPaths = [
    'assets/audio/compfest.mp3',
    'assets/audio/song1.mp3',
    'assets/audio/song2.mp3',
    'assets/audio/song3.mp3',
    'assets/audio/song4.mp3',
    'assets/audio/song5.mp3',
  ];

  // Function to control audio playback
  void playAudio(String path) async {
    await audioPlayer.stop(); // Stop the currently playing song
    await audioPlayer.play(UrlSource(path));
    setState(() {
      isPlaying = true; // Change playback state to true
    });
  }

  void stopAudio() async {
    await audioPlayer.stop(); // Stop the song
    setState(() {
      isPlaying = false; // Change playback state to false
    });
  }

  return ListView.builder(
    itemCount: songs.length,
    itemBuilder: (context, index) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 61, 109, 121),
              blurRadius: 4.0, // Adjust the blur radius to control the shadow spread
              spreadRadius: 1.0, // Adjust the spread radius for more or less shadow
              offset: Offset(0, 2), // Changes position of shadow
            ),
          ],
        ),
        child: Card(
          color: Colors.white, // Set Card color to white
          child: ListTile(
            leading: Image.asset('assets/images/music.png'),
            title: Text(
              songs[index],
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.play_arrow, color: Color.fromARGB(255, 61, 109, 121)),
                  onPressed: () => playAudio(songPaths[index]),
                ),
                IconButton(
                  icon: Icon(Icons.stop, color: Color.fromARGB(255, 61, 109, 121)),
                  onPressed: stopAudio,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}


}