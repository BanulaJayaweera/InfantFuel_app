// weight_entry_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class WeightEntry {
  final String babyId;
  final double weight;
  final DateTime date;

  WeightEntry({
    required this.babyId,
    required this.weight,
    required this.date,
  });

  // Factory method to create WeightEntry from Firestore data
  factory WeightEntry.fromFirestore(Map<String, dynamic> data) {
    return WeightEntry(
      babyId: data['babyId'] as String,
      weight: (data['weight'] as num).toDouble(), // Convert num to double
      date: (data['date'] as Timestamp).toDate(), // Convert Timestamp to DateTime
    );
  }

  // Optional: Method to convert WeightEntry back to a map for saving (if needed)
  Map<String, dynamic> toFirestore() {
    return {
      'babyId': babyId,
      'weight': weight,
      'date': date,
    };
  }
}