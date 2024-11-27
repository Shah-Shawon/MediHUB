import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRecord extends StatefulWidget {
  const UserRecord({super.key, required DateTime selectedDate});

  @override
  _UserRecordState createState() => _UserRecordState();
}

class _UserRecordState extends State<UserRecord> {
  String? _userId;
  List<Map<String, dynamic>> _records = [];

  @override
  void initState() {
    super.initState();
    _getUserIdAndFetchRecords();
  }

  Future<void> _getUserIdAndFetchRecords() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
      await _fetchFitnessData();
    }
  }

  Future<void> _fetchFitnessData() async {
    if (_userId == null) return;

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('FitnessTracker')
          .doc(_userId)
          .collection('records')
          .get();

      final List<Map<String, dynamic>> fetchedRecords =
          snapshot.docs.map((doc) {
        return {
          'date': doc['date'],
          'stepCount': doc['stepCount'],
          'caloriesBurned': doc['caloriesBurned'],
          'height': doc['height'],
          'weight': doc['weight'],
          'bodyFat': doc['bodyFat'],
          'bmi': doc['bmi'],
          'heartRate': doc['heartRate'],
          'bloodPressure': doc['bloodPressure'],
          'sleepDuration': doc['sleepDuration'],
        };
      }).toList();

      setState(() {
        _records = fetchedRecords;
      });
    } catch (e) {
      print('Error fetching records: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View Records')),
      body: _records.isEmpty
          ? const Center(child: Text('No records available.'))
          : ListView.builder(
              itemCount: _records.length,
              itemBuilder: (context, index) {
                final record = _records[index];
                return Card(
                  child: ListTile(
                    title: Text('Date: ${record['date']}'),
                    subtitle: Text(
                      'Steps: ${record['stepCount']}, Calories: ${record['caloriesBurned']}\n'
                      'Height: ${record['height']} cm, Weight: ${record['weight']} kg\n'
                      'BMI: ${record['bmi']}, Body Fat: ${record['bodyFat']}%\n'
                      'Heart Rate: ${record['heartRate']} bpm, Blood Pressure: ${record['bloodPressure']} mmHg\n'
                      'Sleep: ${record['sleepDuration']} hrs',
                    ),
                  ),
                );
              },
            ),
    );
  }
}
