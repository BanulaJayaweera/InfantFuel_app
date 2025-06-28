import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'healthcare_dashboard_screen.dart';

class HealthcareActionsScreen extends StatefulWidget {
  final String babyId;

  const HealthcareActionsScreen({super.key, required this.babyId});

  @override
  State<HealthcareActionsScreen> createState() => _ActionsScreenState();
}

class _ActionsScreenState extends State<HealthcareActionsScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _firstSmileDate;
  DateTime? _standingUpDate;
  DateTime? _walkingDate;
  DateTime? _firstWordsDate;

  Future<void> _selectDate(
    BuildContext context,
    Function(DateTime?) setter,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        setter(picked);
      });
    }
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      List<Map<String, dynamic>> actions = [];
      if (_firstSmileDate != null) {
        actions.add({
          'babyId': widget.babyId,
          'actionType': 'First Smile',
          'scheduledDate': _firstSmileDate,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
      if (_standingUpDate != null) {
        actions.add({
          'babyId': widget.babyId,
          'actionType': 'Standing Up',
          'scheduledDate': _standingUpDate,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
      if (_walkingDate != null) {
        actions.add({
          'babyId': widget.babyId,
          'actionType': 'Walking',
          'scheduledDate': _walkingDate,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
      if (_firstWordsDate != null) {
        actions.add({
          'babyId': widget.babyId,
          'actionType': 'First Words',
          'scheduledDate': _firstWordsDate,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      if (actions.isNotEmpty) {
        // Save all actions to Firestore
        for (var action in actions) {
          FirebaseFirestore.instance.collection('actions').add(action);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Actions saved successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => HealthcareDashboardScreen(babyId: widget.babyId),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one date')),
        );
      }
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
                        "Milestone Actions",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Action Date Pickers
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 20.0,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "First Smile Date",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap:
                                () => _selectDate(
                                  context,
                                  (date) => _firstSmileDate = date,
                                ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _firstSmileDate == null
                                        ? 'Select Date'
                                        : '${_firstSmileDate!.day}/${_firstSmileDate!.month}/${_firstSmileDate!.year}',
                                    style: TextStyle(
                                      color:
                                          _firstSmileDate == null
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
                          const Text(
                            "Standing Up Date",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap:
                                () => _selectDate(
                                  context,
                                  (date) => _standingUpDate = date,
                                ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _standingUpDate == null
                                        ? 'Select Date'
                                        : '${_standingUpDate!.day}/${_standingUpDate!.month}/${_standingUpDate!.year}',
                                    style: TextStyle(
                                      color:
                                          _standingUpDate == null
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
                          const Text(
                            "Walking Date",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap:
                                () => _selectDate(
                                  context,
                                  (date) => _walkingDate = date,
                                ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _walkingDate == null
                                        ? 'Select Date'
                                        : '${_walkingDate!.day}/${_walkingDate!.month}/${_walkingDate!.year}',
                                    style: TextStyle(
                                      color:
                                          _walkingDate == null
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
                          const Text(
                            "First Words Date",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap:
                                () => _selectDate(
                                  context,
                                  (date) => _firstWordsDate = date,
                                ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _firstWordsDate == null
                                        ? 'Select Date'
                                        : '${_firstWordsDate!.day}/${_firstWordsDate!.month}/${_firstWordsDate!.year}',
                                    style: TextStyle(
                                      color:
                                          _firstWordsDate == null
                                              ? Colors.grey
                                              : Colors.black,
                                    ),
                                  ),
                                  const Icon(Icons.calendar_today),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 70),
                          // Save Button
                          ElevatedButton(
                            onPressed: _handleSave,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6A5ACD),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
