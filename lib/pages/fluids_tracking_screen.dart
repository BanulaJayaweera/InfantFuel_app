import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tracking_screen.dart';
import 'health_screen.dart';
import 'dashboard_screen.dart';
import 'extras.dart';

class FluidsTrackingScreen extends StatefulWidget {
  const FluidsTrackingScreen({super.key});

  @override
  State<FluidsTrackingScreen> createState() => _FluidsTrackingScreenState();
}

class _FluidsTrackingScreenState extends State<FluidsTrackingScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedFluid;
  final _volumeController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _notesController = TextEditingController();

  final List<String> _fluidOptions = [
    'Water',
    'Milk',
    'Formula',
    'Breast Milk',
    'Apple Juice',
  ];

  // Nutritional values for 10ml of each fluid
  final Map<String, Map<String, double>> _fluidNutrition = {
    'Water': {
      'carbs_g': 0.0,
      'proteins_g': 0.0,
      'fats_g': 0.0,
      'calories_kcal': 0.0,
    },
    'Milk': {
      'carbs_g': 0.47,
      'proteins_g': 0.33,
      'fats_g': 0.37,
      'calories_kcal': 6.1,
    },
    'Formula': {
      'carbs_g': 0.72,
      'proteins_g': 0.13,
      'fats_g': 0.36,
      'calories_kcal': 6.8,
    },
    'Breast Milk': {
      'carbs_g': 0.69,
      'proteins_g': 0.11,
      'fats_g': 0.41,
      'calories_kcal': 7.0,
    },
    'Apple Juice': {
      'carbs_g': 1.14,
      'proteins_g': 0.01,
      'fats_g': 0.01,
      'calories_kcal': 4.6,
    },
  };

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _handleSaveFeed() async {
    if (_formKey.currentState!.validate() &&
        _selectedFluid != null &&
        _selectedDate != null &&
        _selectedTime != null) {
      try {
        // Combine date and time into a single DateTime object
        final selectedDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );

        // Calculate nutrition based on volume
        final double volume = double.parse(_volumeController.text);
        final double volumeFactor = volume / 10.0;
        final double carbs =
            _fluidNutrition[_selectedFluid]!['carbs_g']! * volumeFactor;
        final double proteins =
            _fluidNutrition[_selectedFluid]!['proteins_g']! * volumeFactor;
        final double fats =
            _fluidNutrition[_selectedFluid]!['fats_g']! * volumeFactor;
        final double calories =
            _fluidNutrition[_selectedFluid]!['calories_kcal']! * volumeFactor;

        // Save to Firestore
        await FirebaseFirestore.instance.collection('fluids_tracking').add({
          'fluid_type': _selectedFluid,
          'volume_ml': volume,
          'datetime': Timestamp.fromDate(selectedDateTime),
          'carbs_g': carbs,
          'proteins_g': proteins,
          'fats_g': fats,
          'calories_kcal': calories,
          'notes': _notesController.text,
          'timestamp': Timestamp.now(),
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feed saved successfully')),
        );

        // Navigate back to TrackingScreen
        Navigator.pop(context);
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving feed: $e')));
      }
    } else {
      if (_selectedFluid == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a fluid type')),
        );
      } else if (_selectedDate == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please select a date')));
      } else if (_selectedTime == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please select a time')));
      }
    }
  }

  @override
  void dispose() {
    _volumeController.dispose();
    _notesController.dispose();
    super.dispose();
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
                            "Tracking\nFluids",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Form Section with White Background Box
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 20.0,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Fluid Type Dropdown
                            const Text(
                              "Type of Fluid",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                              ),
                              hint: const Text('Select Fluid Type'),
                              value: _selectedFluid,
                              items:
                                  _fluidOptions.map((String fluid) {
                                    return DropdownMenuItem<String>(
                                      value: fluid,
                                      child: Text(fluid),
                                    );
                                  }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedFluid = newValue;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            // Volume Input
                            const Text(
                              "Volume (ml)",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _volumeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: 'Enter volume in ml',
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 15,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the volume';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            // Date Picker
                            const Text(
                              "Date",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () => _selectDate(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 15,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _selectedDate == null
                                          ? 'Select Date'
                                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                      style: TextStyle(
                                        color:
                                            _selectedDate == null
                                                ? Colors.grey
                                                : Colors.black,
                                      ),
                                    ),
                                    const Icon(Icons.calendar_today),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Time Picker
                            const Text(
                              "Time",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () => _selectTime(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 15,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _selectedTime == null
                                          ? 'Select Time'
                                          : _selectedTime!.format(context),
                                      style: TextStyle(
                                        color:
                                            _selectedTime == null
                                                ? Colors.grey
                                                : Colors.black,
                                      ),
                                    ),
                                    const Icon(Icons.access_time),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Notes Input
                            const Text(
                              "Notes (Optional)",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _notesController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: 'Add any notes if needed',
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Save Feed Button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 20.0,
                    ),
                    child: ElevatedButton(
                      onPressed: _handleSaveFeed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A5ACD),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Save Feed',
                        style: TextStyle(fontSize: 18),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: 1, // Statistics tab is active
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
