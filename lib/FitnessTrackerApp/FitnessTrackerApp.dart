import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medibd/FitnessTrackerApp/UserRecord.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.teal[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      home: const FitnessTrackerApp(),
    );
  }
}

class FitnessTrackerApp extends StatefulWidget {
  const FitnessTrackerApp({super.key});

  @override
  _FitnessTrackerAppState createState() => _FitnessTrackerAppState();
}

class _FitnessTrackerAppState extends State<FitnessTrackerApp> {
  final TextEditingController _stepCountController = TextEditingController();
  final TextEditingController _caloriesBurnedController =
      TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _bodyFatController = TextEditingController();
  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _bloodPressureController =
      TextEditingController();
  final TextEditingController _sleepDurationController =
      TextEditingController();

  double bmi = 0.0;
  String? _userId;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  Future<void> _getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
    }
  }

  void _calculateBMI() {
    double height =
        double.parse(_heightController.text) / 100; // Convert cm to meters
    double weight = double.parse(_weightController.text);
    setState(() {
      bmi = weight / (height * height);
    });
  }

  Future<void> _saveFitnessData() async {
    if (_userId == null) {
      print('User not logged in!');
      return;
    }

    final String date =
        '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}';

    await FirebaseFirestore.instance
        .collection('FitnessTracker')
        .doc(_userId)
        .collection('records')
        .doc(date)
        .set({
      'userId': _userId,
      'date': date,
      'stepCount': _stepCountController.text,
      'caloriesBurned': _caloriesBurnedController.text,
      'height': _heightController.text,
      'weight': _weightController.text,
      'bodyFat': _bodyFatController.text,
      'bmi': bmi,
      'heartRate': _heartRateController.text,
      'bloodPressure': _bloodPressureController.text,
      'sleepDuration': _sleepDurationController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved successfully!')));
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Tracker'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.velocity.pixelsPerSecond.dx > 0) {
            _changeDate(-1); // Swipe right: Previous day
          } else if (details.velocity.pixelsPerSecond.dx < 0) {
            _changeDate(1); // Swipe left: Next day
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Track Your Fitness!',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => _changeDate(-1),
                    ),
                    Text(
                      '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () => _changeDate(1),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: const Text(
                    'Choose Date',
                    style: TextStyle(color: Colors.teal, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                _buildInputField('Step Count', _stepCountController),
                _buildInputField('Calories Burned', _caloriesBurnedController),
                _buildInputField('Height (cm)', _heightController),
                _buildInputField('Weight (kg)', _weightController),
                _buildInputField('Body Fat (%)', _bodyFatController),
                _buildInputField('Heart Rate (bpm)', _heartRateController),
                _buildInputField(
                    'Blood Pressure (mmHg)', _bloodPressureController),
                _buildInputField(
                    'Sleep Duration (hrs)', _sleepDurationController),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _calculateBMI,
                  child: const Text('Calculate BMI'),
                ),
                const SizedBox(height: 20),
                Text('BMI: ${bmi.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveFitnessData,
                  child: const Text('Save Data'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              UserRecord(selectedDate: _selectedDate)),
                    );
                  },
                  child: const Text('View Records'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: Icon(Icons.edit, color: Colors.teal),
        ),
      ),
    );
  }
}
