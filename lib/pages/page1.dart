import 'package:flutter/material.dart';
import 'page2.dart'; // Import the SignupScreen for navigation

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Curved background shape
            Positioned(
              top: 300,
              left: 0,
              right: 0,
              child: Container(
                height: 900,
                width: 500,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 247, 220, 203),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(350, 200),
                    topRight: Radius.elliptical(350, 200),
                  ),
                ),
              ),
            ),
            // Main content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and App Name
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'images/logo.png',
                        width: 300,
                        height: 300,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.error,
                            size: 100,
                            color: Colors.red,
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const Spacer(),
                // Welcome Text
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    'Start your journey to track and support your baby’s growth with ease because every milestone matters!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, height: 1.5),
                  ),
                ),
                const SizedBox(height: 20),
                // Dots Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF8B5A2B),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Get Started Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: const Center(
                      child: Text(
                        'GET STARTED',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // Copyright Text
                const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'COPYRIGHT © 2024 • EES206 SOFTWARE PROJECT.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
