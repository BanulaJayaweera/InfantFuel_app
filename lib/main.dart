import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/page1.dart'; // Import the WelcomeScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const InfantFuelApp());
}

class InfantFuelApp extends StatelessWidget {
  const InfantFuelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner
      title: 'InfantFuel', // App title
      theme: ThemeData(
        primarySwatch: Colors.blue, // Customize the primary color if needed
        scaffoldBackgroundColor: const Color.fromARGB(
          255,
          243,
          241,
          240,
        ), // Default background color for all screens
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(
              0xFF6A5ACD,
            ), // Default button color (purple)
            foregroundColor: Colors.white, // Default text/icon color on buttons
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black54), // Default text style
        ),
      ),
      home:
          const WelcomeScreen(), // Set the WelcomeScreen as the initial screen
    );
  }
}

// this is the login page code. now when a user who has registered as a healthcare provider logins with his email and password he
