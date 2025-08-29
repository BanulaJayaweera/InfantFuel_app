import 'package:flutter/material.dart';
import 'vaccination_tracking_screen.dart';
import 'healthcare_weight_screen.dart';
import 'baby_list.dart';
import 'healthcare_height_screen.dart';
import 'BMI.dart';
import 'healthcare_actions_screen.dart';
import 'healthcare_medication.dart ';

class HealthcareDashboardScreen extends StatelessWidget {
  final String babyId; // Receive babyId from BabyListPage

  const HealthcareDashboardScreen({super.key, required this.babyId});

  // Placeholder actions for the clickable options
  void _onVaccineTapped(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VaccinationTrackingScreen(babyId: babyId),
      ),
    );
  }

  void _onWeightTapped(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HealthcareWeightScreen(babyId: babyId),
      ),
    );
  }

  void _onActionsTapped(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HealthcareActionsScreen(babyId: babyId),
      ),
    );
  }

  void _onMedicationTapped(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MedicationLogScreen()),
    );
  }

  void _onHeightTapped(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HealthcareHeightScreen(babyId: babyId),
      ),
    );
  }

  void _onBMITapped(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HealthcareBMIScreen(babyId: babyId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Curved background shape
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
                  // Logo and Title
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, left: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                            left: 30.0,
                            top: 8.0,
                            bottom: 8.0,
                            right: 8.0,
                          ),
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
                          child: Image.asset(
                            'images/logo.png',
                            width: 100,
                            height: 80,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.error,
                                size: 100,
                                color: Colors.red,
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withAlpha(51),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Text(
                            "Healthcare Dashboard",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Dashboard Options Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 20.0,
                    ),
                    child: Column(
                      children: [
                        // Vaccine Option
                        GestureDetector(
                          onTap: () => _onVaccineTapped(context),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            margin: const EdgeInsets.only(bottom: 20.0),
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
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.vaccines,
                                  color: Color(0xFF6A5ACD),
                                  size: 40,
                                ),
                                const SizedBox(width: 20),
                                const Text(
                                  "Vaccine",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Weight Option
                        GestureDetector(
                          onTap: () => _onWeightTapped(context),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            margin: const EdgeInsets.only(bottom: 20.0),
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
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.scale,
                                  color: Color(0xFF6A5ACD),
                                  size: 40,
                                ),
                                const SizedBox(width: 20),
                                const Text(
                                  "Weight",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Actions Option
                        GestureDetector(
                          onTap: () => _onActionsTapped(context),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            margin: const EdgeInsets.only(bottom: 20.0),
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
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.checklist,
                                  color: Color(0xFF6A5ACD),
                                  size: 40,
                                ),
                                const SizedBox(width: 20),
                                const Text(
                                  "Actions",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Height Option
                        GestureDetector(
                          onTap: () => _onHeightTapped(context),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            margin: const EdgeInsets.only(bottom: 20.0),
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
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.height,
                                  color: Color(0xFF6A5ACD),
                                  size: 40,
                                ),
                                const SizedBox(width: 20),
                                const Text(
                                  "Height",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // BMI Option
                        GestureDetector(
                          onTap: () => _onBMITapped(context),
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
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.health_and_safety,
                                  color: Color(0xFF6A5ACD),
                                  size: 40,
                                ),
                                const SizedBox(width: 20),
                                const Text(
                                  "BMI",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 200),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar with 2 buttons
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.arrow_back), label: 'Back'),
        ],
        currentIndex: 0, // Dashboard tab is active
        selectedItemColor: const Color(0xFF6A5ACD),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            // Do nothing, already on dashboard
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BabyListPage()),
            );
          }
        },
      ),
    );
  }
}
