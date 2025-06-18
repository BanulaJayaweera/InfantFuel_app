import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'tracking_screen.dart';
import 'health_screen.dart';
import 'dashboard_screen.dart';
import 'extras.dart';

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({super.key});

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sicknessController = TextEditingController();
  int _selectedDays = 1; // Default time period in days
  final _notesController = TextEditingController();
  File? _selectedImage;
  bool _isUploading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _selectPhoto() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _selectDays(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Row(
            children: [
              Expanded(
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 50,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedDays = index + 1; // 1 to 30 days
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: 30, // 1 to 30 days
                    builder: (context, index) {
                      return Center(
                        child: Text(
                          '${index + 1} day${index == 0 ? '' : 's'}',
                          style: const TextStyle(fontSize: 20),
                        ),
                      );
                    },
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Done',
                  style: TextStyle(fontSize: 18, color: Color(0xFF6A5ACD)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleSaveMedicine() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isUploading = true;
      });

      try {
        String? photoUrl;
        // Upload image to Firebase Storage if selected
        if (_selectedImage != null) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('medication_photos')
              .child('${Timestamp.now().millisecondsSinceEpoch}.jpg');
          await storageRef.putFile(_selectedImage!);
          photoUrl = await storageRef.getDownloadURL();
        }

        // Save to Firestore
        await FirebaseFirestore.instance.collection('medication_history').add({
          'sickness': _sicknessController.text.trim(),
          'time_period_days': _selectedDays,
          'notes': _notesController.text.trim(),
          'photo_url': photoUrl,
          'timestamp': Timestamp.now(),
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Medication saved successfully')),
        );

        // Navigate back to HealthScreen
        Navigator.pop(context);
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving medication: $e')));
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the sickness')),
      );
    }
  }

  @override
  void dispose() {
    _sicknessController.dispose();
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
                ),
              ),
            ),
            // Main content
            SingleChildScrollView(
              child: Column(
                children: [
                  // Logo and Title
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
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
                            borderRadius: BorderRadius.circular(50),
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
                            "Health\nMedication",
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
                  // Form Section with White Background
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 20.0,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
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
                            // Add a Photo
                            const Text(
                              "Add a Photo (Optional)",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: _selectPhoto,
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[100],
                                ),
                                child: Center(
                                  child:
                                      _selectedImage == null
                                          ? const Icon(
                                            Icons.add_a_photo,
                                            color: Color(0xFF6A5ACD),
                                            size: 40,
                                          )
                                          : Image.file(
                                            _selectedImage!,
                                            fit: BoxFit.cover,
                                          ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Sickness Input
                            const Text(
                              "Sickness",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _sicknessController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: 'Enter sickness',
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 15,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter the sickness';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            // Time Period Picker
                            const Text(
                              "Time Period",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () => _selectDays(context),
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
                                      '$_selectedDays day${_selectedDays == 1 ? '' : 's'}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    const Icon(Icons.arrow_drop_down),
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
                  // Save Medicine Button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 20.0,
                    ),
                    child: ElevatedButton(
                      onPressed: _isUploading ? null : _handleSaveMedicine,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A5ACD),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child:
                          _isUploading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                'Save Medicine',
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
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Health'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: 2, // Health tab is active
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
}
