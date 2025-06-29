import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'tracking_screen.dart';
import 'health_screen.dart';
import 'dashboard_screen.dart';
import 'extras.dart';

class NutritionTrackingSummary extends StatefulWidget {
  const NutritionTrackingSummary({super.key});

  @override
  State<NutritionTrackingSummary> createState() => _NutritionTrackingSummaryState();
}

class _NutritionTrackingSummaryState extends State<NutritionTrackingSummary> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));
    DateTime startOfDay = DateTime(now.year, now.month, now.day);

    if (FirebaseAuth.instance.currentUser == null) {
      return const Center(child: Text('Please log in to view data'));
    }

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
                            "Nutrition\nSummary",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Summary Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 20.0,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Daily Nutrition Summary (${now.day}/${now.month}/${now.year})",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6A5ACD),
                            ),
                          ),
                          const SizedBox(height: 15),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('solids_tracking')
                                .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
                                .snapshots(),
                            builder: (context, solidsSnapshot) {
                              if (!solidsSnapshot.hasData) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              double totalCarbs = 0.0;
                              double totalProteins = 0.0;
                              double totalFats = 0.0;
                              double totalCalories = 0.0;

                              for (var doc in solidsSnapshot.data!.docs) {
                                final data = doc.data() as Map<String, dynamic>;
                                totalCarbs += (data['carbs_g'] as num?)?.toDouble() ?? 0.0;
                                totalProteins += (data['proteins_g'] as num?)?.toDouble() ?? 0.0;
                                totalFats += (data['fats_g'] as num?)?.toDouble() ?? 0.0;
                                totalCalories += (data['calories_kcal'] as num?)?.toDouble() ?? 0.0;
                              }

                              return StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('fluids_tracking')
                                    .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
                                    .snapshots(),
                                builder: (context, fluidsSnapshot) {
                                  if (!fluidsSnapshot.hasData) {
                                    return const Center(child: CircularProgressIndicator());
                                  }

                                  for (var doc in fluidsSnapshot.data!.docs) {
                                    final data = doc.data() as Map<String, dynamic>;
                                    totalCarbs += (data['carbs_g'] as num?)?.toDouble() ?? 0.0;
                                    totalProteins += (data['proteins_g'] as num?)?.toDouble() ?? 0.0;
                                    totalFats += (data['fats_g'] as num?)?.toDouble() ?? 0.0;
                                    totalCalories += (data['calories_kcal'] as num?)?.toDouble() ?? 0.0;
                                  }

                                  return StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('breastfeeding_sessions')
                                        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
                                        .snapshots(),
                                    builder: (context, breastfeedingSnapshot) {
                                      if (!breastfeedingSnapshot.hasData) {
                                        return const Center(child: CircularProgressIndicator());
                                      }

                                      for (var doc in breastfeedingSnapshot.data!.docs) {
                                        final data = doc.data() as Map<String, dynamic>;
                                        totalCalories += (data['calories'] as num?)?.toDouble() ?? 0.0;
                                      }

                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _buildNutrientCard(
                                            icon: Icons.local_dining,
                                            label: 'Carbohydrates',
                                            value: totalCarbs.toStringAsFixed(1),
                                            unit: 'g',
                                          ),
                                          const SizedBox(height: 10),
                                          _buildNutrientCard(
                                            icon: Icons.local_pizza,
                                            label: 'Proteins',
                                            value: totalProteins.toStringAsFixed(1),
                                            unit: 'g',
                                          ),
                                          const SizedBox(height: 10),
                                          _buildNutrientCard(
                                            icon: Icons.fastfood,
                                            label: 'Fats',
                                            value: totalFats.toStringAsFixed(1),
                                            unit: 'g',
                                          ),
                                          const SizedBox(height: 10),
                                          _buildNutrientCard(
                                            icon: Icons.local_fire_department,
                                            label: 'Calories',
                                            value: totalCalories.toStringAsFixed(1),
                                            unit: 'kcal',
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Past Entries Table
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 10.0,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Last 5 Nutrition Entries",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6A5ACD),
                            ),
                          ),
                          const SizedBox(height: 10),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('solids_tracking')
                                .orderBy('timestamp', descending: true)
                                .limit(5)
                                .snapshots(),
                            builder: (context, solidsSnapshot) {
                              if (!solidsSnapshot.hasData) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              final solidsData = solidsSnapshot.data!.docs.map((doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                final timestamp = (data['timestamp'] as Timestamp).toDate();
                                return {
                                  'date': '${timestamp.day}/${timestamp.month}/${timestamp.year}',
                                  'time': '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                                  'type': 'Solids',
                                };
                              }).toList();

                              return StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('fluids_tracking')
                                    .orderBy('timestamp', descending: true)
                                    .limit(5)
                                    .snapshots(),
                                builder: (context, fluidsSnapshot) {
                                  if (!fluidsSnapshot.hasData) {
                                    return const Center(child: CircularProgressIndicator());
                                  }
                                  final fluidsData = fluidsSnapshot.data!.docs.map((doc) {
                                    final data = doc.data() as Map<String, dynamic>;
                                    final timestamp = (data['timestamp'] as Timestamp).toDate();
                                    String type = 'Fluids';
                                    if (data['fluid_type'] == 'Breast Milk') type = 'Breastfeeding';
                                    return {
                                      'date': '${timestamp.day}/${timestamp.month}/${timestamp.year}',
                                      'time': '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                                      'type': type,
                                    };
                                  }).toList();

                                  return StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('breastfeeding_sessions')
                                        .orderBy('timestamp', descending: true)
                                        .limit(5)
                                        .snapshots(),
                                    builder: (context, breastfeedingSnapshot) {
                                      if (!breastfeedingSnapshot.hasData) {
                                        return const Center(child: CircularProgressIndicator());
                                      }
                                      final breastfeedingData = breastfeedingSnapshot.data!.docs.map((doc) {
                                        final data = doc.data() as Map<String, dynamic>;
                                        final timestamp = (data['timestamp'] as Timestamp).toDate();
                                        return {
                                          'date': '${timestamp.day}/${timestamp.month}/${timestamp.year}',
                                          'time': '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                                          'type': 'Breastfeeding',
                                        };
                                      }).toList();

                                      final allData = [...solidsData, ...fluidsData, ...breastfeedingData];
                                      allData.sort((a, b) {
                                        DateTime parseDateTime(Map<String, String> entry) {
                                          final dateParts = entry['date']!.split('/');
                                          final timeParts = entry['time']!.split(':');
                                          return DateTime(
                                            int.parse(dateParts[2]),
                                            int.parse(dateParts[1]),
                                            int.parse(dateParts[0]),
                                            int.parse(timeParts[0]),
                                            int.parse(timeParts[1]),
                                          );
                                        }
                                        return parseDateTime(b).compareTo(parseDateTime(a));
                                      });
                                      final lastFive = allData.take(5).toList();

                                      return SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: DataTable(
                                          columnSpacing: 20.0,
                                          columns: const [
                                            DataColumn(label: Text('Date')),
                                            DataColumn(label: Text('Time')),
                                            DataColumn(label: Text('Type')),
                                          ],
                                          rows: lastFive.map((entry) {
                                            return DataRow(cells: [
                                              DataCell(Text(entry['date']!)),
                                              DataCell(Text(entry['time']!)),
                                              DataCell(Text(entry['type']!)),
                                            ]);
                                          }).toList(),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
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
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Health'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: 1, // Statistics tab is active (aligned with tracking summary)
        selectedItemColor: const Color(0xFF6A5ACD),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TrackingScreen()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HealthScreen()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ExtrasScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _buildNutrientCard({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
  }) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6A5ACD), size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$value $unit',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A5ACD),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}