import 'package:flutter/material.dart';
import 'package:infantfuel_mobile/pages/health_screen.dart';
import 'weight_tracking_screen.dart';
import 'height_tracking_screen.dart';
import 'head_tracking_screen.dart';
import 'breastfeeding_screen.dart';
import 'fluids_tracking_screen.dart';
import 'solids_tracking_screen.dart';
import 'extras.dart';
import 'dashboard_screen.dart';
import 'nutrition_summary.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  // Placeholder functions for button clicks
  void _onWeightTapped(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WeightTrackingScreen()),
    );
  }

  void _onHeightTapped(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HeightTrackingScreen()),
    );
  }

  void _onHeadCircumferenceTapped(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HeadTrackingScreen()),
    );
  }

  void _onBreastfeedingTapped(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BreastfeedingTrackingScreen(),
      ),
    );
  }

  void _onFluidsTapped(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FluidsTrackingScreen()),
    );
  }

  void _onSolidsTapped(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SolidsTrackingScreen()),
    );
  }

  void _onGrowthSummaryTapped() {
    print('Navigate to Growth Summary Screen (to be implemented)');
  }

  void _onNutritionSummaryTapped(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NutritionTrackingSummary()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Curved background shape (matching DashboardScreen)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 1500,
                width: 500,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 247, 220, 203),
                  borderRadius: BorderRadius.only(),
                ),
              ),
            ),
            // Main content
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50.0, 300.0, 8.0),
                    child: Column(
                      children: [
                        Container(
                          width: 200,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withAlpha(51),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              10.0,
                              8.0,
                              8.0,
                              8.0,
                            ),
                            child: Image.asset(
                              'images/logo.png', // Using the logo.png as in other screens
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.error,
                                  size: 200,
                                  color: Colors.red,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Title
                  Padding(
                    padding: const EdgeInsets.fromLTRB(230, 0.0, 10.0, 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withAlpha(51),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Tracking",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Growth Tracking Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: [
                        Row(
                          // Removed the Growth Tracking "Summary" TextButton so only the title remains
                          children: const [
                            Text(
                              "Growth Tracking",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Weight Button
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _onWeightTapped(context),
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withAlpha(51),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.scale,
                                        color: Color(0xFF6A5ACD),
                                        size: 40,
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        "Weight",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Height Button
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _onHeightTapped(context),
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withAlpha(51),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.height,
                                        color: Color(0xFF6A5ACD),
                                        size: 40,
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        "Height",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Head Circumference Button
                            Expanded(
                              child: GestureDetector(
                                onTap:
                                    () => _onHeadCircumferenceTapped(context),
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withAlpha(51),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.face,
                                        color: Color(0xFF6A5ACD),
                                        size: 40,
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        "Head\ncircumference",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 11.5),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Nutrition Tracking Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Nutrition Tracking",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed:
                                  () => _onNutritionSummaryTapped(context),
                              child: const Row(
                                children: [
                                  Text(
                                    "Summary",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF6A5ACD),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(Icons.menu, color: Color(0xFF6A5ACD)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Breastfeeding Button
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _onBreastfeedingTapped(context),
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withAlpha(51),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.child_care,
                                        color: Color(0xFF6A5ACD),
                                        size: 40,
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        "Breastfeeding",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Fluids Button
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _onFluidsTapped(context),
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withAlpha(51),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.local_drink,
                                        color: Color(0xFF6A5ACD),
                                        size: 40,
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        "Fluids",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Solids Button
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _onSolidsTapped(context),
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withAlpha(51),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.food_bank,
                                        color: Color(0xFF6A5ACD),
                                        size: 40,
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        "Solids",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 130),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Tracking',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Health'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Extras'),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: 1, // Statistics tab is active
        selectedItemColor: const Color(0xFF6A5ACD),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HealthScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExtrasScreen()),
            );
          }
        },
      ),
    );
  }
}
