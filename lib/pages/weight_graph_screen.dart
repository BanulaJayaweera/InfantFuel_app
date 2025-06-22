// lib/screens/weight_graph_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'weight_entry_model.dart'; // Adjust path based on your project structure
import 'healthcare_dashboard_screen.dart';

class WeightGraphScreen extends StatefulWidget {
  final String babyId;

  const WeightGraphScreen({super.key, required this.babyId});

  @override
  State<WeightGraphScreen> createState() => _WeightGraphScreenState();
}

class _WeightGraphScreenState extends State<WeightGraphScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight Graph for ${widget.babyId}'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('weight tracking')
                .where('babyId', isEqualTo: widget.babyId)
                .orderBy('date')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                print('Stream Error: ${snapshot.error}'); // Log the error
                return Center(child: Text('Error loading data: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No weight data available'));
              }

              final weightEntries = <WeightEntry>[];
              for (var doc in snapshot.data!.docs) {
                try {
                  final data = doc.data() as Map<String, dynamic>;
                  print('Doc data: $data'); // Log each document
                  weightEntries.add(WeightEntry.fromFirestore(data));
                } catch (e) {
                  print('Deserialization Error for doc ${doc.id}: $e');
                  continue; // Skip invalid documents
                }
              }

              if (weightEntries.isEmpty) {
                return const Center(child: Text('No valid weight data available'));
              }

              return LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: (weightEntries.length / 5).clamp(1, double.infinity),
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < weightEntries.length) {
                            final date = weightEntries[index].date;
                            return Text(
                              '${date.day}/${date.month}/${date.year}',
                              style: const TextStyle(color: Colors.black, fontSize: 10),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) => Text(
                          value.toStringAsFixed(1),
                          style: const TextStyle(color: Colors.black, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  minX: 0,
                  maxX: weightEntries.length - 1,
                  minY: 0,
                  maxY: (weightEntries.map((e) => e.weight).reduce((a, b) => a > b ? a : b) + 1).clamp(1, double.infinity),
                  lineBarsData: [
                    LineChartBarData(
                      spots: weightEntries.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value.weight);
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue,
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
          BottomNavigationBarItem(icon: Icon(Icons.arrow_back), label: 'back'),
        ],
        currentIndex: 0,
        selectedItemColor: const Color(0xFF6A5ACD),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HealthcareDashboardScreen(babyId: widget.babyId),
              ),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HealthcareDashboardScreen(babyId: widget.babyId),
              ),
            );
          }
        },
      ),
    );
  }
}