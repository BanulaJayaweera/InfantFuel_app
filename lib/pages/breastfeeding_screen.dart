import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class BreastfeedingTrackingScreen extends StatefulWidget {
  const BreastfeedingTrackingScreen({super.key});

  @override
  State<BreastfeedingTrackingScreen> createState() =>
      _BreastfeedingTrackingScreenState();
}

class _BreastfeedingTrackingScreenState
    extends State<BreastfeedingTrackingScreen> {
  bool _isTimerRunning = false;
  bool _isTimerPaused = false;
  int _seconds = 0;
  String _selectedSide = '';
  late Timer _timer;
  String _displayText = "Choose L or R to start the timer";

  @override
  void initState() {
    super.initState();
    // Initialize timer (will be started when needed)
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {});
    _timer.cancel(); // Cancel immediately until started
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (!_isTimerRunning) {
      _isTimerRunning = true;
      _isTimerPaused = false;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!_isTimerPaused) {
          setState(() {
            _seconds++;
          });
        }
      });
    }
  }

  Future<void> _stopTimer() async {
    if (_isTimerRunning) {
      _timer.cancel();
      try {
        // Calculate calories (55 calories per second)
        double kcal = _seconds * 55.0;
        // Save to Firestore
        await FirebaseFirestore.instance
            .collection('breastfeeding_sessions')
            .add({
              'side': _selectedSide,
              'duration_seconds': _seconds,
              'kcal': kcal,
              'timestamp': Timestamp.now(),
            });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Breastfeeding session saved')),
        );
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving session: $e')));
      }

      setState(() {
        _isTimerRunning = false;
        _isTimerPaused = false;
        _seconds = 0;
        _displayText = "Choose L or R to start the timer";
        _selectedSide = '';
      });
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showSideSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Side'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.looks_one),
                title: const Text('Left (L)'),
                onTap: () {
                  setState(() {
                    _selectedSide = 'L';
                    _displayText = 'Left (L)';
                  });
                  _startTimer();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.looks_two),
                title: const Text('Right (R)'),
                onTap: () {
                  setState(() {
                    _selectedSide = 'R';
                    _displayText = 'Right (R)';
                  });
                  _startTimer();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToManualEntry() {
    String manualEntry = '';
    String? selectedSide;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Manual Entry'),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Enter time (MM:SS)',
                      hintText: 'e.g., 10:30',
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      manualEntry = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    hint: const Text('Select Side'),
                    value: selectedSide,
                    items:
                        ['L', 'R'].map((side) {
                          return DropdownMenuItem<String>(
                            value: side,
                            child: Text(side == 'L' ? 'Left (L)' : 'Right (R)'),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedSide = value;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Validate manual entry format (MM:SS)
                RegExp timeRegex = RegExp(r'^\d{1,2}:\d{2}$');
                if (manualEntry.isEmpty || !timeRegex.hasMatch(manualEntry)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter time in MM:SS format'),
                    ),
                  );
                  return;
                }
                if (selectedSide == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a side')),
                  );
                  return;
                }

                // Parse MM:SS to seconds
                List<String> parts = manualEntry.split(':');
                int minutes = int.parse(parts[0]);
                int seconds = int.parse(parts[1]);
                int totalSeconds = minutes * 60 + seconds;

                // Calculate calories (55 calories per second)
                double kcal = totalSeconds * 55.0 * 0.001;

                try {
                  // Save to Firestore
                  await FirebaseFirestore.instance
                      .collection('breastfeeding_sessions')
                      .add({
                        'side': selectedSide,
                        'duration_seconds': totalSeconds,
                        'kcal': kcal,
                        'timestamp': Timestamp.now(),
                      });

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Manual entry saved')),
                  );
                } catch (e) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error saving entry: $e')),
                  );
                }

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
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
                            "Tracking\nBreastfeeding",
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
                  const SizedBox(height: 100),
                  // Timer and Control Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 20.0,
                    ),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _displayText,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            Icon(
                              Icons.child_care,
                              color: const Color(0xFF6A5ACD),
                              size: 60,
                            ),
                            if (_isTimerRunning)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20.0,
                                ),
                                child: Text(
                                  _formatTime(_seconds),
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed:
                                      _isTimerRunning
                                          ? null
                                          : _showSideSelectionDialog,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6A5ACD),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('Start'),
                                ),
                                ElevatedButton(
                                  onPressed:
                                      _isTimerRunning ? _stopTimer : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6A5ACD),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('Stop'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                  // Add Manual Entry Button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 20.0,
                    ),
                    child: ElevatedButton(
                      onPressed: _navigateToManualEntry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A5ACD),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Add manual Entry',
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
            Navigator.pop(context); // Pop to TrackingScreen
          } else if (index == 1) {
            Navigator.pop(context);
          } else if (index == 2) {
            print('Navigate to Favorites Screen (to be implemented)');
          } else if (index == 3) {
            print('Navigate to Settings Screen (to be implemented)');
          }
        },
      ),
    );
  }
}
