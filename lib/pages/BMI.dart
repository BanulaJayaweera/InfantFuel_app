import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'healthcare_dashboard_screen.dart';

class HealthcareBMIScreen extends StatefulWidget {
  final String babyId;

  const HealthcareBMIScreen({super.key, required this.babyId});

  @override
  State<HealthcareBMIScreen> createState() => _BMITrackingScreenState();
}

class _BMITrackingScreenState extends State<HealthcareBMIScreen> {
  double? _currentBMI;

  @override
  void initState() {
    super.initState();
    _calculateBMI();
  }

  Future<void> _calculateBMI() async {
    try {
      // Fetch latest weight
      final weightSnapshot =
          await FirebaseFirestore.instance
              .collection('weight tracking')
              .where('babyId', isEqualTo: widget.babyId)
              .orderBy('date', descending: true)
              .limit(1)
              .get();

      if (weightSnapshot.docs.isEmpty) {
        setState(() {
          _currentBMI = null;
        });
        return;
      }
      final latestWeight =
          weightSnapshot.docs.first.data() as Map<String, dynamic>;
      final weight = (latestWeight['weight'] as num).toDouble();

      // Fetch latest height
      final heightSnapshot =
          await FirebaseFirestore.instance
              .collection('height tracking')
              .where('babyId', isEqualTo: widget.babyId)
              .orderBy('date', descending: true)
              .limit(1)
              .get();

      if (heightSnapshot.docs.isEmpty) {
        setState(() {
          _currentBMI = null;
        });
        return;
      }
      final latestHeight =
          heightSnapshot.docs.first.data() as Map<String, dynamic>;
      final height = (latestHeight['height'] as num).toDouble();

      // Calculate BMI: weight (kg) / (height (m) * height (m))
      final heightInMeters = height / 100; // Convert cm to m
      final bmi = weight / (heightInMeters * heightInMeters);

      setState(() {
        _currentBMI = double.parse(bmi.toStringAsFixed(2));
      });
    } catch (e) {
      print('Error calculating BMI: $e');
      setState(() {
        _currentBMI = null;
      });
    }
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
                    padding: const EdgeInsets.only(
                      top: 30.0,
                      left: 0.0,
                      right: 10.0,
                    ),
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
                            "Tracking",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Subtitle
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 10.0,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "BMI tracking",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // BMI Display
                  const SizedBox(height: 100),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0),
                    child: Center(
                      child:
                          _currentBMI == null
                              ? const Text(
                                '',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              )
                              : Text(
                                'Current BMI: ${_currentBMI}',
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 500),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.arrow_back), label: 'back'),
        ],
        currentIndex: 0, // Dashboard tab is active
        selectedItemColor: const Color(0xFF6A5ACD),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        HealthcareDashboardScreen(babyId: widget.babyId),
              ),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        HealthcareDashboardScreen(babyId: widget.babyId),
              ),
            );
          }
        },
      ),
    );
  }
}
