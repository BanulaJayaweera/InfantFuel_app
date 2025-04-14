import 'package:flutter/material.dart';
import 'page3.dart'; // Import LoginScreen for navigation

class HealthcareRegistrationScreen extends StatefulWidget {
  const HealthcareRegistrationScreen({super.key});

  @override
  State<HealthcareRegistrationScreen> createState() =>
      _HealthcareRegistrationScreenState();
}

class _HealthcareRegistrationScreenState
    extends State<HealthcareRegistrationScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _fullNameController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _workplaceAddressController = TextEditingController();
  final _positionController = TextEditingController();
  final _medicalRegNumberController = TextEditingController();

  // Dropdown values
  String? _selectedDistrict;
  String? _selectedGramaNiladhari;

  // Dropdown options (same as page 4)
  final List<String> _districts = ['Kalutara', 'Colombo'];
  final List<String> _gramaNiladhariDivisions = ['Kalutara', 'Colombo'];

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _fullNameController.dispose();
    _contactNumberController.dispose();
    _workplaceAddressController.dispose();
    _positionController.dispose();
    _medicalRegNumberController.dispose();
    super.dispose();
  }

  // Basic validation for full name
  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    return null;
  }

  // Basic validation for contact number
  String? _validateContactNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your contact number';
    }
    final phoneRegex = RegExp(r'^\d{10}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  // Basic validation for workplace address
  String? _validateWorkplaceAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your workplace address';
    }
    return null;
  }

  // Basic validation for position/designation
  String? _validatePosition(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your position/designation';
    }
    return null;
  }

  // Basic validation for medical registration number
  String? _validateMedicalRegNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your medical registration number';
    }
    return null;
  }

  // Handle form submission
  void _handleProceed() {
    if (_formKey.currentState!.validate() &&
        _selectedDistrict != null &&
        _selectedGramaNiladhari != null) {
      // Form is valid, proceed with submission
      print('Full Name: ${_fullNameController.text}');
      print('District: $_selectedDistrict');
      print('Grama Niladhari Division: $_selectedGramaNiladhari');
      print('Contact Number: ${_contactNumberController.text}');
      print('Workplace Address: ${_workplaceAddressController.text}');
      print('Position/Designation: ${_positionController.text}');
      print('Medical Registration Number: ${_medicalRegNumberController.text}');

      // Navigate to the next screen (to be implemented)
      // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
    } else if (_selectedDistrict == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a district')));
    } else if (_selectedGramaNiladhari == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a Grama Niladhari Division'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Curved background shape (matching SignupScreen and ParentRegistrationScreen)
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
                      "Please fill in the below details to register as healthcare provider.",
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
                            controller: _fullNameController,
                            decoration: InputDecoration(
                              hintText: 'Enter your Full Name',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: _validateFullName,
                          ),
                          const SizedBox(height: 15),
                          DropdownButtonFormField<String>(
                            value: _selectedDistrict,
                            hint: const Text('District'),
                            items:
                                _districts.map((String district) {
                                  return DropdownMenuItem<String>(
                                    value: district,
                                    child: Text(district),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedDistrict = newValue;
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
                          const SizedBox(height: 15),
                          DropdownButtonFormField<String>(
                            value: _selectedGramaNiladhari,
                            hint: const Text('Grama Niladhari Division'),
                            items:
                                _gramaNiladhariDivisions.map((String division) {
                                  return DropdownMenuItem<String>(
                                    value: division,
                                    child: Text(division),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedGramaNiladhari = newValue;
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
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _contactNumberController,
                            decoration: InputDecoration(
                              hintText: 'Contact number',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: _validateContactNumber,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _workplaceAddressController,
                            decoration: InputDecoration(
                              hintText: 'Enter your workplace Address',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: _validateWorkplaceAddress,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _positionController,
                            decoration: InputDecoration(
                              hintText: 'Position/Designation',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: _validatePosition,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _medicalRegNumberController,
                            decoration: InputDecoration(
                              hintText: 'Medical Registration number',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: _validateMedicalRegNumber,
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
                      onPressed: _handleProceed,
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Already have an account? Sign in',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6A5ACD),
                        decoration: TextDecoration.underline,
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
    );
  }
}
