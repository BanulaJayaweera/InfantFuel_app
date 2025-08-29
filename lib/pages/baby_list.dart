import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'healthcare_dashboard_screen.dart';
import 'page3.dart'; // Assume this is the login screen widget

class BabyListPage extends StatefulWidget {
  const BabyListPage({super.key});

  @override
  State<BabyListPage> createState() => _BabyListPageState();
}

class _BabyListPageState extends State<BabyListPage> {
  List<String> _babyNames = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBabyNames();
  }

  Future<void> _fetchBabyNames() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final hpEmail = user.email;
        String hpFullName;
        switch (hpEmail) {
          case 'asela@gmail.com':
            hpFullName = 'Dr Asela Athukorala';
            break;
          case 'amalka@gmail.com':
            hpFullName = 'Dr Amalka Perera';
            break;
          case 'saman@gmail.com':
            hpFullName = 'Dr Saman Perera';
            break;
          default:
            hpFullName = '';
        }
        if (hpFullName.isNotEmpty) {
          final snapshot =
              await FirebaseFirestore.instance
                  .collection('parent-HP connections')
                  .where('hpName', isEqualTo: hpFullName)
                  .get();
          setState(() {
            _babyNames =
                snapshot.docs.map((doc) => doc['babyName'] as String).toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            _babyNames = ['No babies assigned'];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching baby names: $e');
      setState(() {
        _babyNames = ['Error loading babies'];
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load baby names: $e')));
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
                            "Baby List",
                            textAlign: TextAlign.center,
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
                  // Baby List Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 20.0,
                    ),
                    child: Column(
                      children: [
                        if (_isLoading)
                          const Center(child: CircularProgressIndicator())
                        else if (_babyNames.isEmpty ||
                            _babyNames[0].startsWith('Error') ||
                            _babyNames[0].startsWith('No'))
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'No babies assigned or error occurred',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        else
                          ..._babyNames.map((babyName) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => HealthcareDashboardScreen(
                                          babyId: babyName,
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                margin: const EdgeInsets.only(bottom: 20.0),
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
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.child_care,
                                      color: Color(0xFF6A5ACD),
                                      size: 40,
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      babyName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 300),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(50.0),
        color: const Color.fromARGB(255, 247, 220, 203),
        child: ElevatedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 194, 65, 65),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Logout', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
