import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tracking_screen.dart';
import 'health_screen.dart';
import 'dashboard_screen.dart';
import 'extras.dart';

class SolidsTrackingScreen extends StatefulWidget {
  const SolidsTrackingScreen({super.key});

  @override
  State<SolidsTrackingScreen> createState() => _SolidsTrackingScreenState();
}

class _SolidsTrackingScreenState extends State<SolidsTrackingScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedFood;
  int _selectedQuantity = 10; // Default quantity in grams
  DateTime? _selectedDate;
  final _carbsController = TextEditingController();
  final _proteinsController = TextEditingController();
  final _fatsController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _notesController = TextEditingController();
  final _foodNameController = TextEditingController();

  final List<String> _foodOptions = [
    'None',
    'Rice',
    'Noodles',
    'Pureed Carrot',
    'Mashed Banana',
    'Oatmeal Porridge',
  ];
  bool _isManualNutritionEnabled = true;
  bool _isFoodQuantityEnabled = true;

  // Nutritional values for 10g of each food
  final Map<String, Map<String, double>> _foodNutrition = {
    'Rice': {
      'carbs_g': 2.8,
      'proteins_g': 0.3,
      'fats_g': 0.1,
      'calories_kcal': 13.0,
    },
    'Noodles': {
      'carbs_g': 2.5,
      'proteins_g': 0.4,
      'fats_g': 0.2,
      'calories_kcal': 13.1,
    },
    'Pureed Carrot': {
      'carbs_g': 0.8,
      'proteins_g': 0.1,
      'fats_g': 0.0,
      'calories_kcal': 3.5,
    },
    'Mashed Banana': {
      'carbs_g': 2.3,
      'proteins_g': 0.1,
      'fats_g': 0.0,
      'calories_kcal': 8.9,
    },
    'Oatmeal Porridge': {
      'carbs_g': 1.2,
      'proteins_g': 0.3,
      'fats_g': 0.2,
      'calories_kcal': 6.8,
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

  void _selectQuantity(BuildContext context) {
    if (!_isFoodQuantityEnabled) return;
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
                      _selectedQuantity = (index + 1) * 10; // 10g increments
                      if (_selectedFood != null &&
                          _selectedFood != 'None' &&
                          _selectedQuantity > 0) {
                        _isManualNutritionEnabled = false;
                      }
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: 20, // 10g to 200g
                    builder: (context, index) {
                      return Center(
                        child: Text(
                          '${(index + 1) * 10} g',
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

  void _checkInputState() {
    bool hasManualInput = _carbsController.text.isNotEmpty ||
        _proteinsController.text.isNotEmpty ||
        _fatsController.text.isNotEmpty ||
        _caloriesController.text.isNotEmpty;
    bool hasFoodQuantity =
        _selectedFood != null && _selectedFood != 'None' && _selectedQuantity > 0;

    setState(() {
      _isManualNutritionEnabled = !hasFoodQuantity || _selectedFood == 'None';
      _isFoodQuantityEnabled = !hasManualInput;
    });
  }

  Future<void> _handleSaveFeed() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      if (_selectedFood == null && _isFoodQuantityEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a food type')),
        );
        return;
      }

      try {
        double carbs = 0.0;
        double proteins = 0.0;
        double fats = 0.0;
        double calories = 0.0;

        if (_selectedFood != null &&
            _selectedFood != 'None' &&
            _foodNutrition.containsKey(_selectedFood)) {
          // Calculate nutrition based on quantity
          double quantityFactor = _selectedQuantity / 10.0;
          carbs = _foodNutrition[_selectedFood]!['carbs_g']! * quantityFactor;
          proteins =
              _foodNutrition[_selectedFood]!['proteins_g']! * quantityFactor;
          fats = _foodNutrition[_selectedFood]!['fats_g']! * quantityFactor;
          calories =
              _foodNutrition[_selectedFood]!['calories_kcal']! * quantityFactor;
        } else {
          // Use manual nutrition values
          carbs = _carbsController.text.isEmpty
              ? 0.0
              : double.parse(_carbsController.text);
          proteins = _proteinsController.text.isEmpty
              ? 0.0
              : double.parse(_proteinsController.text);
          fats = _caloriesController.text.isEmpty
              ? 0.0
              : double.parse(_fatsController.text);
          calories = _caloriesController.text.isEmpty
              ? 0.0
              : double.parse(_caloriesController.text);
        }

        // Save to Firestore
        await FirebaseFirestore.instance.collection('solids_tracking').add({
          'food_type': _selectedFood,
          'food_name': _foodNameController.text.trim(),
          'quantity_g': _selectedQuantity,
          'date': _selectedDate != null ? Timestamp.fromDate(_selectedDate!) : null,
          'carbs_g': carbs,
          'proteins_g': proteins,
          'fats_g': fats,
          'calories_kcal': calories,
          
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving feed: $e')),
        );
      }
    } else {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a date')),
        );
      }
    }
  }

  @override
  void dispose() {
    _carbsController.dispose();
    _proteinsController.dispose();
    _fatsController.dispose();
    _caloriesController.dispose();
    _notesController.dispose();
    _foodNameController.dispose();
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
                            "Tracking\nSolids",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // First Form Section (Food Type, Quantity, Date)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 10.0,
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
                            // Food Type Dropdown
                            const Text(
                              "Type of Food",
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
                              hint: const Text('Select Food Type'),
                              value: _selectedFood,
                              items: _foodOptions.map((String food) {
                                return DropdownMenuItem<String>(
                                  value: food,
                                  child: Text(food),
                                );
                              }).toList(),
                              onChanged: _isFoodQuantityEnabled
                                  ? (String? newValue) {
                                      setState(() {
                                        _selectedFood = newValue;
                                        _isManualNutritionEnabled =
                                            newValue == 'None' ||
                                            (newValue == null || _selectedQuantity == 0);
                                      });
                                    }
                                  : null,
                            ),
                            const SizedBox(height: 20),
                            // Quantity Picker
                            const Text(
                              "Quantity (g)",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: _selectedFood == 'None'
                                  ? null
                                  : () => _selectQuantity(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 15,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _isFoodQuantityEnabled &&
                                            _selectedFood != 'None'
                                        ? Colors.grey
                                        : Colors.grey.withOpacity(0.5),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: _isFoodQuantityEnabled &&
                                          _selectedFood != 'None'
                                      ? Colors.white
                                      : Colors.grey.withOpacity(0.1),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '$_selectedQuantity g',
                                      style: TextStyle(
                                        color: _isFoodQuantityEnabled &&
                                                _selectedFood != 'None'
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: _isFoodQuantityEnabled &&
                                              _selectedFood != 'None'
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _selectedDate == null
                                          ? 'Select Date'
                                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                      style: TextStyle(
                                        color: _selectedDate == null
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                    const Icon(Icons.calendar_today),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Second Form Section (Manual Nutrition, Food Name, Notes)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 10.0,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Manual Nutrition Input
                          const Text(
                            "Manual Nutrition (Optional)",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _carbsController,
                                  keyboardType: TextInputType.number,
                                  enabled: _isManualNutritionEnabled,
                                  decoration: InputDecoration(
                                    labelText: 'Carbs (g)',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 15,
                                    ),
                                    filled: !_isManualNutritionEnabled,
                                    fillColor: Colors.grey.withOpacity(0.1),
                                  ),
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      if (double.tryParse(value) == null) {
                                        return 'Please enter a valid number';
                                      }
                                    }
                                    return null;
                                  },
                                  onChanged: (value) => _checkInputState(),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: _proteinsController,
                                  keyboardType: TextInputType.number,
                                  enabled: _isManualNutritionEnabled,
                                  decoration: InputDecoration(
                                    labelText: 'Proteins (g)',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 15,
                                    ),
                                    filled: !_isManualNutritionEnabled,
                                    fillColor: Colors.grey.withOpacity(0.1),
                                  ),
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      if (double.tryParse(value) == null) {
                                        return 'Please enter a valid number';
                                      }
                                    }
                                    return null;
                                  },
                                  onChanged: (value) => _checkInputState(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _fatsController,
                                  keyboardType: TextInputType.number,
                                  enabled: _isManualNutritionEnabled,
                                  decoration: InputDecoration(
                                    labelText: 'Fats (g)',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 15,
                                    ),
                                    filled: !_isManualNutritionEnabled,
                                    fillColor: Colors.grey.withOpacity(0.1),
                                  ),
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      if (double.tryParse(value) == null) {
                                        return 'Please enter a valid number';
                                      }
                                    }
                                    return null;
                                  },
                                  onChanged: (value) => _checkInputState(),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: _caloriesController,
                                  keyboardType: TextInputType.number,
                                  enabled: _isManualNutritionEnabled,
                                  decoration: InputDecoration(
                                    labelText: 'Calories (kcal)',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 15,
                                    ),
                                    filled: !_isManualNutritionEnabled,
                                    fillColor: Colors.grey.withOpacity(0.1),
                                  ),
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      if (double.tryParse(value) == null) {
                                        return 'Please enter a valid number';
                                      }
                                    }
                                    return null;
                                  },
                                  onChanged: (value) => _checkInputState(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Food Name Input
                          const Text(
                            "Name of Food",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _foodNameController,
                            enabled: _isManualNutritionEnabled,
                            decoration: InputDecoration(
                              labelText: 'Enter name of food',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 15,
                              ),
                              filled: !_isManualNutritionEnabled,
                              fillColor: Colors.grey.withOpacity(0.1),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Notes Input
                         
                        ],
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