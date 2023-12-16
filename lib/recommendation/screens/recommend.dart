import 'dart:async';
import 'package:flutter/material.dart';
import 'package:literakarya_mobile/homepage/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:literakarya_mobile/recommendation/screens/form_recommend.dart';
import 'package:provider/provider.dart';
import 'package:literakarya_mobile/recommendation/models/recommendation.dart';

// Assuming you already have the Rekomendasi class defined

// Function to fetch recommendations
Future<List<Rekomendasi>> fetchRecommendations() async {
  final response = await http.get(Uri.parse('http://localhost:8000/recommendation/json/'));

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

  @override
  void initState() {
    super.initState();
    futureRecommendations = fetchRecommendations();
  }

void navigateAndRefresh() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => FormRecommend()),
  );

  if (result == true) {
    setState(() {
      futureRecommendations = fetchRecommendations();
    });
  }
}

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Recommendation',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontFamily: 'Sansita',
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      leading: Padding(
        padding: EdgeInsets.all(5.0),
        child: Image.asset("assets/images/logo_literakarya.png"),
      ),
    ),
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
                ElevatedButton(
                  onPressed: () => setState(() {
                    showBookRecommendations = true;
                  }),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // To wrap the content of the row
                    children: <Widget>[
                      Image.asset(
                        'assets/images/minibook.png', // Replace with your asset name
                        height: 20, // Set the size as you need
                        width: 20,
                      ),
                      SizedBox(width: 8), // Spacing between the icon and text
                      Text(
                        'Book Recommendation',
                        style: TextStyle(
                          color: Color.fromARGB(255, 6, 0, 0),
                          fontSize: 12.0,
                          fontFamily: 'Sansita',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: showBookRecommendations ? Color(0xFFF9BE5A) : Color.fromARGB(255, 254, 255, 255),
                    padding: EdgeInsets.symmetric(horizontal: 12), // Add padding if needed
                  ),
                ),
                ElevatedButton(
                  onPressed: () => setState(() {
                    showBookRecommendations = false;
                  }),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // To wrap the content of the row
                    children: <Widget>[
                      Image.asset(
                        'assets/images/gramaphone.png', // Replace with your asset name
                        height: 20, // Set the size as you need
                        width: 20,
                      ),
                      SizedBox(width: 8), // Spacing between the icon and text
                      Text(
                        'Music Playlist',
                        style: TextStyle(
                          color: Color.fromARGB(255, 6, 0, 0),
                          fontSize: 12.0,
                          fontFamily: 'Sansita',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: showBookRecommendations ?Color.fromARGB(255, 254, 255, 255) : Color(0xFFF9BE5A),
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
                'Hello, User!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Sansita',
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

  Widget bookCard(Fields fields) {
  // This widget builds an individual card for a book.
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 5,
    color: Color.fromARGB(255, 61, 109, 121),
    margin: const EdgeInsets.all(8),
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
            fields.genreBuku,
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
            fields.isiRekomendasi,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
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
              primary: Theme.of(context).primaryColor, // Use your primary color here
              onPrimary: Colors.white, // Text color
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Rekomendasi>>(
            future: futureRecommendations,
            builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While waiting for the response, show a loading spinner.
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // If we run into an error, display it to the user.
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              // If we have data, display it in a GridView.
              return GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.6, // Adjust as needed
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Rekomendasi recommendation = snapshot.data![index];
                  Fields fields = recommendation.fields;
                  return bookCard(fields); // Your book card widget
                },
              );
            } else {
              // If there's no data, show a message to the user.
              return Center(child: Text("No recommendations found."));
            }
          },
          ),
        ),
      ],
    );
    
  }

  Widget musicPlaylistView() {
    return SizedBox();
    // The method content for musicPlaylistView goes here
  }

}

