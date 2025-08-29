import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'height_entry_model.dart'; // Adjust path based on your project structure
import 'healthcare_dashboard_screen.dart';

class HeightGraphScreen extends StatefulWidget {
  final String babyId;

  const HeightGraphScreen({super.key, required this.babyId});

  @override
  State<HeightGraphScreen> createState() => _HeightGraphScreenState();
}

class _HeightGraphScreenState extends State<HeightGraphScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Height Graph for ${widget.babyId}')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection('height tracking')
                    .where('babyId', isEqualTo: widget.babyId)
                    .orderBy('date')
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                print('Stream Error: ${snapshot.error}'); // Log the error
                return Center(
                  child: Text('Error loading data: ${snapshot.error}'),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No height data available'));
              }

              final heightEntries = <HeightEntry>[];
              for (var doc in snapshot.data!.docs) {
                try {
                  final data = doc.data() as Map<String, dynamic>;
                  print('Doc data: $data'); // Log each document
                  heightEntries.add(HeightEntry.fromFirestore(data));
                } catch (e) {
                  print('Deserialization Error for doc ${doc.id}: $e');
                  continue; // Skip invalid documents
                }
              }

              if (heightEntries.isEmpty) {
                return const Center(
                  child: Text('No valid height data available'),
                );
              }

              return LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: (heightEntries.length / 5).clamp(
                          1,
                          double.infinity,
                        ),
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < heightEntries.length) {
                            final date = heightEntries[index].date;
                            return Text(
                              '${date.day}/${date.month}/${date.year}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 5, // Adjusted for height scale (e.g., cm)
                        getTitlesWidget:
                            (value, meta) => Text(
                              value.toStringAsFixed(0),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                            ),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  minX: 0,
                  maxX: heightEntries.length - 1,
                  minY: 0,
                  maxY: (heightEntries
                              .map((e) => e.height)
                              .reduce((a, b) => a > b ? a : b) +
                          5)
                      .clamp(5, double.infinity),
                  lineBarsData: [
                    LineChartBarData(
                      spots:
                          heightEntries.asMap().entries.map((entry) {
                            return FlSpot(
                              entry.key.toDouble(),
                              entry.value.height,
                            );
                          }).toList(),
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 2,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.arrow_back), label: 'Back'),
        ],
        currentIndex: 0,
        selectedItemColor: const Color(0xFF6A5ACD),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        HealthcareDashboardScreen(babyId: widget.babyId),
              ),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
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
