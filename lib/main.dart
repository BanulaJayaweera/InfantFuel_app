import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/page1.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(); 
  runApp(const InfantFuelApp());
}

class InfantFuelApp extends StatelessWidget {
  const InfantFuelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'InfantFuel', 
      theme: ThemeData(
        primarySwatch: Colors.blue, 
        scaffoldBackgroundColor: const Color.fromARGB(
          255,
          243,
          241,
          240,
        ), // 
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
