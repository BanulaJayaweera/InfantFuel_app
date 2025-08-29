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

  // Method to convert WeightEntry back to a map for saving (if needed)
  Map<String, dynamic> toFirestore() {
    return {
      'babyId': babyId,
      'weight': weight,
      'date': date,
    };
  }
}

class HeightEntry {
  final String babyId;
  final double height;
  final DateTime date;

  HeightEntry({
    required this.babyId,
    required this.height,
    required this.date,
  });

  // Factory method to create HeightEntry from Firestore data
  factory HeightEntry.fromFirestore(Map<String, dynamic> data) {
    return HeightEntry(
      babyId: data['babyId'] as String,
      height: (data['height'] as num).toDouble(), // Convert num to double
      date: (data['date'] as Timestamp).toDate(), // Convert Timestamp to DateTime
    );
  }

  // Method to convert HeightEntry back to a map for saving (if needed)
  Map<String, dynamic> toFirestore() {
    return {
      'babyId': babyId,
      'height': height,
      'date': date,
    };
  }
}