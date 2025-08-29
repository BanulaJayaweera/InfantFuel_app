import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard_screen.dart';
import 'tracking_screen.dart';
import 'extras.dart';
import 'health_screen.dart';

class VaccinationLogScreen extends StatefulWidget {
  final String babyId;

  const VaccinationLogScreen({super.key, required this.babyId});

  @override
  State<VaccinationLogScreen> createState() => _VaccinationLogScreenState();
}

class _VaccinationLogScreenState extends State<VaccinationLogScreen> {
  @override
  void initState() {
    super.initState();
    print('Loading vaccination log for babyId: ${widget.babyId}'); // Debug log
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vaccination Log for ${widget.babyId}')),
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
                    "Vaccination History",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 1),
                  StreamBuilder<QuerySnapshot>(
                    stream:
                        FirebaseFirestore.instance
                            .collection('vaccination_history')
                            .where('babyId', isEqualTo: widget.babyId)
                            .orderBy('date', descending: true)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        print('Stream Error: ${snapshot.error}'); // Debug error
                        return const Center(
                          child: Text('Error loading vaccination data'),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        print(
                          'No data found for babyId: ${widget.babyId}',
                        ); // Debug log
                        return const Center(
                          child: Text('No vaccination data available'),
                        );
                      }

                      final vaccinations =
                          snapshot.data!.docs.map((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            // Debug the raw data
                            print('Document data: $data');
                            return {
                              'vaccine':
                                  data['vaccine'] as String? ?? 'Unknown',
                              'date':
                                  data['date'] != null
                                      ? (data['date'] is Timestamp
                                          ? (data['date'] as Timestamp).toDate()
                                          : DateTime.parse(
                                            data['date'].toString(),
                                          ))
                                      : DateTime.now(), // Fallback if date is missing or invalid
                              'dosage':
                                  data['dosage'] != null
                                      ? data['dosage']
                                          .toString() // Convert to string for display
                                      : 'N/A', // Fallback if dosage is missing
                            };
                          }).toList();

                      if (vaccinations.isEmpty) {
                        print(
                          'Parsed vaccinations list is empty for babyId: ${widget.babyId}',
                        );
                        return const Center(
                          child: Text('No vaccination data available'),
                        );
                      }

                      return SizedBox(
                        width: double.infinity,
                        // approximate available vertical space so the table can be centered vertically
                        height:
                            MediaQuery.of(context).size.height -
                            kToolbarHeight -
                            200,
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: DataTable(
                                columnSpacing:
                                    30.0, // Increased spacing for wider columns
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
                                      'Vaccine',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Date',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Dosage',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                                rows:
                                    vaccinations.map((vaccination) {
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10.0,
                                                  ), // Add padding for width
                                              child: Text(
                                                vaccination['vaccine']
                                                    as String,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10.0,
                                                  ), // Add padding for width
                                              child: Text(
                                                vaccination['date'] != null
                                                    ? '${(vaccination['date'] as DateTime).day}/${(vaccination['date'] as DateTime).month}/${(vaccination['date'] as DateTime).year}'
                                                    : 'Unknown',
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10.0,
                                                  ), // Add padding for width
                                              child: Text(
                                                vaccination['dosage'] as String,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Tracking',
          ),
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
              MaterialPageRoute(builder: (context) => DashboardScreen()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TrackingScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HealthScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExtrasScreen()),
            );
          }
        },
      ),
    );
  }
}
