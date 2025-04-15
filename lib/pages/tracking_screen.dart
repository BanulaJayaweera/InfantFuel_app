import 'package:flutter/material.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  // Placeholder functions for button clicks
  void _onWeightTapped() {
    print('Navigate to Weight Tracking Screen (to be implemented)');
  }

  void _onHeightTapped() {
    print('Navigate to Height Tracking Screen (to be implemented)');
  }

  void _onHeadCircumferenceTapped() {
    print('Navigate to Head Circumference Tracking Screen (to be implemented)');
  }

  void _onBreastfeedingTapped() {
    print('Navigate to Breastfeeding Tracking Screen (to be implemented)');
  }

  void _onFluidsTapped() {
    print('Navigate to Fluids Tracking Screen (to be implemented)');
  }

  void _onSolidsTapped() {
    print('Navigate to Solids Tracking Screen (to be implemented)');
  }

  void _onGrowthSummaryTapped() {
    print('Navigate to Growth Summary Screen (to be implemented)');
  }

  void _onNutritionSummaryTapped() {
    print('Navigate to Nutrition Summary Screen (to be implemented)');
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
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Column(
                      children: [
                        Container(
                          width: 150,
                          height: 80,
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
                              50.0,
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
                                  size: 150,
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
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 10.0,
                    ),
                    child: Text(
                      "Tracking",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Growth Tracking Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Growth Tracking",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: _onGrowthSummaryTapped,
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
                            // Weight Button
                            Expanded(
                              child: GestureDetector(
                                onTap: _onWeightTapped,
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
                                        style: TextStyle(fontSize: 16),
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
                                onTap: _onHeightTapped,
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
                                        style: TextStyle(fontSize: 16),
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
                                onTap: _onHeadCircumferenceTapped,
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
                                        style: TextStyle(fontSize: 16),
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
                  const SizedBox(height: 20),
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
                              onPressed: _onNutritionSummaryTapped,
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
                                onTap: _onBreastfeedingTapped,
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
                                        style: TextStyle(fontSize: 16),
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
                                onTap: _onFluidsTapped,
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
                                        style: TextStyle(fontSize: 16),
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
                                onTap: _onSolidsTapped,
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
                                        style: TextStyle(fontSize: 16),
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
                  const SizedBox(height: 70),
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
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: 1, // Statistics tab is active
        selectedItemColor: const Color(0xFF6A5ACD),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context); // Go back to DashboardScreen
          } else if (index == 2) {
            print('Navigate to Favorites Screen (to be implemented)');
          } else if (index == 3) {
            print('Navigate to Settings Screen (to be implemented)');
          }
        },
      ),
    );
  }
}
