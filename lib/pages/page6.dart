import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this import at the top // Import LoginScreen for navigation
import 'dashboard_screen.dart'; // Import DashboardScreen for navigation

class BabyDetailsScreen extends StatefulWidget {
  const BabyDetailsScreen({super.key});

  @override
  State<BabyDetailsScreen> createState() => _BabyDetailsScreenState();
}

class _BabyDetailsScreenState extends State<BabyDetailsScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _babyNameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _headCircumferenceController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  

  // Date of birth
  DateTime? _selectedDate;

  // Gender dropdown value
  String? _selectedGender;

  // Gender dropdown options
  final List<String> _genders = ['Male', 'Female'];

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _babyNameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _bloodGroupController.dispose();
    _birthPlaceController.dispose();
    _headCircumferenceController.dispose();
    super.dispose();
  }

  // Basic validation for baby's name
  String? _validateBabyName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your baby\'s name';
    }
    return null;
  }

  // Basic validation for weight
  String? _validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the weight at birth';
    }
    final weight = double.tryParse(value);
    if (weight == null || weight <= 0) {
      return 'Please enter a valid weight';
    }
    return null;
  }

  // Basic validation for height
  String? _validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the height at birth';
    }
    final height = double.tryParse(value);
    if (height == null || height <= 0) {
      return 'Please enter a valid height';
    }
    return null;
  }

   String? _validateHeadCircumference(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the Head Circumference at birth';
    }
    final height = double.tryParse(value);
    if (height == null || height <= 0) {
      return 'Please enter a valid Head Circumference';
    }
    return null;
  }

  // Basic validation for blood group
  String? _validateBloodGroup(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the blood group';
    }
    return null;
  }

  // Basic validation for birth place
  String? _validateBirthPlace(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the birth place';
    }
    return null;
  }

  // Date picker for date of birth
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Handle form submission
  Future<void> _handleProceed() async {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedGender != null) {
      // Form is valid, proceed with submission

      // Store data in Firestore under 'baby details' collection
      try {
        await FirebaseFirestore.instance.collection('baby details').add({
          'babyName': _babyNameController.text.trim(),
          'dateOfBirth': _selectedDate!.toIso8601String(),
          'gender': _selectedGender,
          'weightAtBirth': _weightController.text.trim(),
          'heightAtBirth': _heightController.text.trim(),
          'headCircumferenceAtBirth': _headCircumferenceController.text.trim(),
          'bloodGroup': _bloodGroupController.text.trim(),
          'birthPlace': _birthPlaceController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Navigate to DashboardScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save baby details: $e')),
        );
      }
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select the date of birth')),
      );
    } else if (_selectedGender == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select the gender')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Curved background shape (matching SignupScreen, ParentRegistrationScreen, etc.)
            Positioned(
              top: 210,
              left: 0,
              right: 0,
              child: Container(
                height: 900,
                width: 500,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 247, 220, 203),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(350, 200),
                    topRight: Radius.elliptical(350, 200),
                  ),
                ),
              ),
            ),
            // Main content
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo and App Name
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Column(
                      children: [
                        Image.asset(
                          'images/logo.png', // Matching the path used in other screens
                          width: 200,
                          height: 200,
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
                  // Welcome Text
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      "Let's get you started!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      "Please enter your baby’s details.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Form Fields
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _babyNameController,
                            decoration: InputDecoration(
                              hintText: 'Baby\'s name',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: _validateBabyName,
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    hintText:
                                        _selectedDate == null
                                            ? 'Date of Birth'
                                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.calendar_today),
                                      onPressed: () => _selectDate(context),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _selectedGender,
                                  hint: const Text('Gender'),
                                  items:
                                      _genders.map((String gender) {
                                        return DropdownMenuItem<String>(
                                          value: gender,
                                          child: Text(gender),
                                        );
                                      }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedGender = newValue;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _weightController,
                            decoration: InputDecoration(
                              hintText: 'Weight at birth',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: _validateWeight,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _heightController,
                            decoration: InputDecoration(
                              hintText: 'Height at birth',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: _validateHeight,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _headCircumferenceController,
                            decoration: InputDecoration(
                              hintText: 'Head Circumference at birth',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: _validateHeadCircumference,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _bloodGroupController,
                            decoration: InputDecoration(
                              hintText: 'Blood group',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: _validateBloodGroup,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _birthPlaceController,
                            decoration: InputDecoration(
                              hintText: 'Birth place',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: _validateBirthPlace,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Proceed Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: ElevatedButton(
                      onPressed:
                          _handleProceed, // Change to: onPressed: () => _handleProceed(),
                      child: const Center(
                        child: Text(
                          'Proceed',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Sign In Link
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
