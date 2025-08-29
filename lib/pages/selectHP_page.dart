import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'contactHP_page.dart'; // Import ContactHPPage
import 'dashboard_screen.dart';
import 'tracking_screen.dart';
import 'health_screen.dart';
import 'extras.dart'; // Import ExtrasScreen

class SelectHPPage extends StatefulWidget {
  final String babyName;

  const SelectHPPage({super.key, required this.babyName});

  @override
  State<SelectHPPage> createState() => _SelectHPPageState();
}

class _SelectHPPageState extends State<SelectHPPage> {
  String? _selectedHP;
  List<String> _hpNames = [];
  bool _isLoading = true; // Track loading state
  bool _hasHPConnection = false; // Track if HP is already selected
  Map<String, dynamic>? _currentHPDetails; // Store current HP details
  bool _isResigning = false; // Track resign state to show dropdown

  @override
  void initState() {
    super.initState();
    _fetchHPNames();
    _checkHPConnection();
  }

  Future<void> _fetchHPNames() async {
    setState(() {
      _isLoading = true; // Show loading state
    });
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('healthcare provider details')
          .get();
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _hpNames = snapshot.docs
              .map((doc) {
                final data = doc.data();
                return data['fullName'] != null && data['fullName'] is String
                    ? data['fullName'] as String
                    : 'Unnamed HP';
              })
              .where((name) => name.isNotEmpty)
              .toList();
          _isLoading = false; // Stop loading
        });
      } else {
        setState(() {
          _hpNames = ['No HPs available'];
          _isLoading = false; // Stop loading
        });
      }
    } catch (e) {
      print('Error fetching HP names: $e');
      setState(() {
        _hpNames = ['Error loading HPs'];
        _isLoading = false; // Stop loading
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to load HP names: $e')));
    }
  }

  Future<void> _checkHPConnection() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('parent-HP connections')
          .where('babyName', isEqualTo: widget.babyName)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        setState(() {
          _hasHPConnection = true;
          _selectedHP = data['hpName'] as String?;
          _fetchHPDetails(_selectedHP); // Fetch details of the current HP
        });
      }
    } catch (e) {
      print('Error checking HP connection: $e');
    }
  }

  Future<void> _fetchHPDetails(String? hpName) async {
    if (hpName == null) return;
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('healthcare provider details')
          .where('fullName', isEqualTo: hpName)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _currentHPDetails = snapshot.docs.first.data();
        });
      }
    } catch (e) {
      print('Error fetching HP details: $e');
    }
  }

  Future<void> _saveHPConnection(String babyName, String hpName) async {
    try {
      // Remove existing connection if it exists
      final existingSnapshot = await FirebaseFirestore.instance
          .collection('parent-HP connections')
          .where('babyName', isEqualTo: babyName)
          .limit(1)
          .get();
      for (var doc in existingSnapshot.docs) {
        await doc.reference.delete();
      }
      // Add new connection
      await FirebaseFirestore.instance.collection('parent-HP connections').add({
        'babyName': babyName,
        'hpName': hpName,
        'timestamp': FieldValue.serverTimestamp(),
      });
      setState(() {
        _hasHPConnection = true;
        _isResigning = false;
      });
      _fetchHPDetails(hpName); // Update with new HP details
    } catch (e) {
      print('Error saving HP connection: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save HP connection: $e')),
      );
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
                            "Select HP",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                  // HP Details or Selection
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 20.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Select Healthcare Provider",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (_isLoading)
                          const Center(child: CircularProgressIndicator())
                        else if (_hasHPConnection && !_isResigning)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current HP: ${_currentHPDetails?['fullName'] ?? _selectedHP}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              if (_currentHPDetails != null)
                                ...[
                                  const SizedBox(height: 10),
                                  Text(
                                    'Email: ${_currentHPDetails?['email'] ?? 'Not available'}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'Phone: ${_currentHPDetails?['phone'] ?? 'Not available'}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isResigning = true;
                                    _selectedHP = null; // Reset selection for new choice
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6A5ACD),
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Resign Healthcare Provider',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          )
                        else if (_isResigning || !_hasHPConnection)
                          DropdownButtonFormField<String>(
                            value: _selectedHP,
                            hint: const Text('Choose a Healthcare Provider'),
                            items: _hpNames.map((name) {
                              return DropdownMenuItem<String>(
                                value: name,
                                child: Text(name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedHP = value;
                              });
                              if (_isResigning) {
                                _fetchHPDetails(value); // Preview new HP details
                              }
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 15,
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _selectedHP == null ||
                                  _isLoading ||
                                  _hpNames[0].startsWith('No') ||
                                  _hpNames[0].startsWith('Error') ||
                                  (_hasHPConnection && !_isResigning)
                              ? null
                              : () async {
                                  await _saveHPConnection(
                                    widget.babyName,
                                    _selectedHP!,
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ContactHPPage(
                                        hpName: _selectedHP!,
                                      ),
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6A5ACD),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 350),
                      ],
                    ),
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
        currentIndex: 3, // Extras tab is active
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