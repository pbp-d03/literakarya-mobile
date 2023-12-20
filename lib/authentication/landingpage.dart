import 'package:flutter/material.dart';
import 'package:literakarya_mobile/authentication/login.dart';


void main() {
  runApp(const StartPage());
}
class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(flex: screenHeight < 400 ? 1 : 3), // Adjust flex based on screen height
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      side: BorderSide(color: Colors.teal),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.025, // Dynamic vertical padding
                      horizontal: screenWidth * 0.09, // Dynamic horizontal padding
                    ),
                  ),
                  child: Text(
                    'Mulai Jelajahi',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04, // Dynamic font size
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade700,
                    ),
                  ),
                ),
                Spacer(), // Keep this Spacer as it is
              ],
            ),
          ),
        ),
      ),
    );
  }
}
