import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tracking_screen.dart'; // Import TrackingScreen for navigation
import 'health_screen.dart';
import 'extras.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex =
      0; // Index for the bottom navigation bar (0 for dashboard)

  // Placeholder function for navigation bar item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigation for other screens (without babyId)
    switch (index) {
      case 0:
        // Already on DashboardScreen
        break;
      case 1:
        // Navigate to TrackingScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TrackingScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HealthScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ExtrasScreen()),
        );
        break;
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
                height: 2000,
                width: 1000,
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
                        Image.asset(
                          'images/dashboard.png',
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
                      ],
                    ),
                  ),
                  // Baby Age
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      "Your baby is 4 months\n1 week old",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                    ),
                  ),

                  // Recent Activity Section (Nutrition Tracking)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Recent Activity",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Nested StreamBuilders similar to Recent Actions to reliably combine latest entries
                          StreamBuilder<QuerySnapshot>(
                            stream:
                                FirebaseFirestore.instance
                                    .collection('fluids tracking')
                                    .orderBy('timestamp', descending: true)
                                    .limit(5)
                                    .snapshots(),
                            builder: (context, fluidsSnapshot) {
                              return StreamBuilder<QuerySnapshot>(
                                stream:
                                    FirebaseFirestore.instance
                                        .collection('solids tracking')
                                        .orderBy('timestamp', descending: true)
                                        .limit(5)
                                        .snapshots(),
                                builder: (context, solidsSnapshot) {
                                  return StreamBuilder<QuerySnapshot>(
                                    stream:
                                        FirebaseFirestore.instance
                                            .collection(
                                              'breastfeeding sessions',
                                            )
                                            .orderBy(
                                              'timestamp',
                                              descending: true,
                                            )
                                            .limit(5)
                                            .snapshots(),
                                    builder: (context, breastfeedingSnapshot) {
                                      if (fluidsSnapshot.connectionState ==
                                              ConnectionState.waiting ||
                                          solidsSnapshot.connectionState ==
                                              ConnectionState.waiting ||
                                          breastfeedingSnapshot
                                                  .connectionState ==
                                              ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      if (fluidsSnapshot.hasError ||
                                          solidsSnapshot.hasError ||
                                          breastfeedingSnapshot.hasError) {
                                        return const Text('Error loading data');
                                      }

                                      final allEntries =
                                          <Map<String, dynamic>>[];

                                      // Fluids entries
                                      final fluidsDocs =
                                          fluidsSnapshot.data?.docs ?? [];
                                      for (final doc in fluidsDocs) {
                                        final ts =
                                            (doc.data()
                                                    as Map<
                                                      String,
                                                      dynamic
                                                    >)['timestamp']
                                                as Timestamp?;
                                        if (ts != null) {
                                          allEntries.add({
                                            'type': 'Fluids',
                                            'timestamp': ts,
                                            'doc': doc.data(),
                                          });
                                        }
                                      }

                                      // Solids entries
                                      final solidsDocs =
                                          solidsSnapshot.data?.docs ?? [];
                                      for (final doc in solidsDocs) {
                                        final ts =
                                            (doc.data()
                                                    as Map<
                                                      String,
                                                      dynamic
                                                    >)['timestamp']
                                                as Timestamp?;
                                        if (ts != null) {
                                          allEntries.add({
                                            'type': 'Solids',
                                            'timestamp': ts,
                                            'doc': doc.data(),
                                          });
                                        }
                                      }

                                      // Breastfeeding entries
                                      final bfDocs =
                                          breastfeedingSnapshot.data?.docs ??
                                          [];
                                      for (final doc in bfDocs) {
                                        final ts =
                                            (doc.data()
                                                    as Map<
                                                      String,
                                                      dynamic
                                                    >)['timestamp']
                                                as Timestamp?;
                                        if (ts != null) {
                                          allEntries.add({
                                            'type': 'Breastfeeding',
                                            'timestamp': ts,
                                            'doc': doc.data(),
                                          });
                                        }
                                      }

                                      // Sort and take latest 3
                                      allEntries.sort(
                                        (a, b) => (b['timestamp'] as Timestamp)
                                            .compareTo(
                                              a['timestamp'] as Timestamp,
                                            ),
                                      );
                                      final latestThree =
                                          allEntries.take(3).toList();

                                      if (latestThree.isEmpty) {
                                        return const Text(
                                          'No nutrition data available',
                                        );
                                      }

                                      return Column(
                                        children:
                                            latestThree.map((entry) {
                                              final timeAgo = calculateTimeAgo(
                                                entry['timestamp'] as Timestamp,
                                              );
                                              final type =
                                                  entry['type'] as String;
                                              IconData icon = Icons.fastfood;
                                              if (type == 'Fluids')
                                                icon = Icons.local_drink;
                                              if (type == 'Breastfeeding')
                                                icon =
                                                    Icons
                                                        .child_care; // Use child_care for breastfeeding
                                              // Fallback if nursing icon is unavailable
                                              if (icon == null)
                                                icon = Icons.fastfood;

                                              String label = type;
                                              final docData =
                                                  entry['doc']
                                                      as Map<String, dynamic>?;
                                              if (docData != null) {
                                                if (type == 'Solids' &&
                                                    docData['foodName'] !=
                                                        null) {
                                                  label =
                                                      'Solids: ${docData['foodName']}';
                                                } else if (type == 'Fluids' &&
                                                    docData['amount'] != null) {
                                                  label =
                                                      'Fluids: ${docData['amount']}';
                                                } else if (type ==
                                                    'Breastfeeding') {
                                                  label = 'Breastfeeding';
                                                }
                                              }

                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 5.0,
                                                    ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      icon,
                                                      color: const Color(
                                                        0xFF6A5ACD,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        "$label: $timeAgo",
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
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
                  const SizedBox(height: 20),
                  // Recent Actions Section (Vaccination/Medication)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Recent Actions",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          StreamBuilder<QuerySnapshot>(
                            stream:
                                FirebaseFirestore.instance
                                    .collection('vaccination_history')
                                    .orderBy('timestamp', descending: true)
                                    .limit(1)
                                    .snapshots(),
                            builder: (context, vaccinationSnapshot) {
                              return StreamBuilder<QuerySnapshot>(
                                stream:
                                    FirebaseFirestore.instance
                                        .collection('medication_history')
                                        .orderBy('timestamp', descending: true)
                                        .limit(1)
                                        .snapshots(),
                                builder: (context, medicationSnapshot) {
                                  if (vaccinationSnapshot.connectionState ==
                                          ConnectionState.waiting ||
                                      medicationSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (vaccinationSnapshot.hasError ||
                                      medicationSnapshot.hasError) {
                                    return const Text('Error loading data');
                                  }

                                  final allEntries = <Map<String, dynamic>>[];
                                  if (vaccinationSnapshot
                                          .data
                                          ?.docs
                                          .isNotEmpty ??
                                      false) {
                                    allEntries.add({
                                      'type': 'vaccination',
                                      'timestamp':
                                          vaccinationSnapshot
                                                  .data!
                                                  .docs
                                                  .first['timestamp']
                                              as Timestamp,
                                    });
                                  }
                                  if (medicationSnapshot
                                          .data
                                          ?.docs
                                          .isNotEmpty ??
                                      false) {
                                    allEntries.add({
                                      'type': 'medication',
                                      'timestamp':
                                          medicationSnapshot
                                                  .data!
                                                  .docs
                                                  .first['timestamp']
                                              as Timestamp,
                                    });
                                  }

                                  allEntries.sort(
                                    (a, b) => b['timestamp'].compareTo(
                                      a['timestamp'],
                                    ),
                                  );
                                  final latestThree =
                                      allEntries.take(3).toList();

                                  return Column(
                                    children:
                                        latestThree.map((entry) {
                                          final timeAgo = calculateTimeAgo(
                                            entry['timestamp'] as Timestamp,
                                          );
                                          final actionType =
                                              entry['type'] == 'vaccination'
                                                  ? 'Vaccination'
                                                  : 'Medication';
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5.0,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  entry['type'] == 'vaccination'
                                                      ? Icons.medical_services
                                                      : Icons.medication,
                                                  color: const Color(
                                                    0xFF6A5ACD,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                const SizedBox(height: 50),
                                                Expanded(
                                                  child: Text(
                                                    "$actionType: $timeAgo",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
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
            label: 'Tracking',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Health'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Extras'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF6A5ACD),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  // Combine nutrition streams
  Stream<List<Map<String, dynamic>>> combineNutritionStreams() async* {
    final List<Map<String, dynamic>> streamConfigs = [
      {
        'collection': 'fluids tracking',
        'type': 'Fluids',
        'stream':
            FirebaseFirestore.instance
                .collection('fluids tracking')
                .orderBy('timestamp', descending: true)
                .limit(5)
                .snapshots(),
      },
      {
        'collection': 'solids tracking',
        'type': 'Solids',
        'stream':
            FirebaseFirestore.instance
                .collection('solids tracking')
                .orderBy('timestamp', descending: true)
                .limit(5)
                .snapshots(),
      },
      {
        'collection': 'breastfeeding sessions',
        'type': 'Breastfeeding',
        'stream':
            FirebaseFirestore.instance
                .collection('breastfeeding sessions')
                .orderBy('timestamp', descending: true)
                .limit(5)
                .snapshots(),
      },
    ];

    List<Map<String, dynamic>> allEntries = [];
    for (final config in streamConfigs) {
      final stream = config['stream'] as Stream<QuerySnapshot>;
      final type = config['type'] as String;
      await for (final snapshot in stream) {
        allEntries.addAll(
          snapshot.docs.map((doc) {
            return {'type': type, 'timestamp': doc['timestamp'] as Timestamp};
          }).toList(),
        );
      }
    }
    allEntries.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
    yield allEntries;
  }

  // Calculate time ago from timestamp
  String calculateTimeAgo(Timestamp timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp.toDate());

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}
