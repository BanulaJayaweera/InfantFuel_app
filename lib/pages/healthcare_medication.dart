import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard_screen.dart';
import 'tracking_screen.dart';
import 'extras.dart';
import 'health_screen.dart';

class MedicationLogScreen extends StatefulWidget {
  const MedicationLogScreen({super.key});

  @override
  State<MedicationLogScreen> createState() => _MedicationLogScreenState();
}

class _MedicationLogScreenState extends State<MedicationLogScreen> {
  @override
  void initState() {
    super.initState();
    print('Initializing MedicationLogScreen'); // Debug initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medication Log')),
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
                width: 1000,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 247, 220, 203),
                  borderRadius: BorderRadius.only(),
                ),
              ),
            ),
            // Main content
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Medication History",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 1),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('medication_history')
                        .orderBy('date', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        print('Stream Error: ${snapshot.error}'); // Debug error
                        return const Center(
                          child: Text('Error loading medication data'),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        print('No medication data found in snapshot'); // Debug log
                        return const Center(
                          child: Text('No medication data available'),
                        );
                      }

                      final medications = snapshot.data!.docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        print('Raw document data: $data'); // Debug raw data
                        return {
                          'sickness': data['sickness'] as String? ?? 'Unknown',
                          'time_period_days': data['time_period_days'] != null
                              ? data['time_period_days'].toString()
                              : 'N/A',
                          'date': data['date'] != null
                              ? (data['date'] is Timestamp
                                  ? (data['date'] as Timestamp).toDate()
                                  : DateTime.tryParse(data['date'].toString()))
                              : DateTime.now(), // Fallback if date is missing
                        };
                      }).toList();

                      if (medications.isEmpty) {
                        print('Parsed medications list is empty.');
                        return const Center(
                          child: Text('No medication data available'),
                        );
                      }

                      return SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height - kToolbarHeight - 200,
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: DataTable(
                                columnSpacing: 30.0,
                                dataRowHeight: 50.0,
                                headingRowHeight: 40.0,
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
                                columns: const [
                                  DataColumn(
                                    label: Text(
                                      'Sickness',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Time Period (Days)',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Date',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                                rows: medications.map((medication) {
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                          child: Text(medication['sickness'] as String),
                                        ),
                                      ),
                                      DataCell(
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                          child: Text(medication['time_period_days'] as String),
                                        ),
                                      ),
                                      DataCell(
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                          child: Text(
                                            medication['date'] != null
                                                ? '${(medication['date'] as DateTime).day}/${(medication['date'] as DateTime).month}/${(medication['date'] as DateTime).year}'
                                                : 'Unknown',
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Tracking'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Health'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Extras'),
        ],
        currentIndex: 2, // Health tab is active
        selectedItemColor: const Color(0xFF6A5ACD),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TrackingScreen()),
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