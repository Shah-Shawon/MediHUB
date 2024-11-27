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
          'id': doc.id, // Add document ID to each record
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

  // Function to delete a record
  Future<void> _deleteRecord(String recordId) async {
    try {
      await FirebaseFirestore.instance
          .collection('FitnessTracker')
          .doc(_userId)
          .collection('records')
          .doc(recordId)
          .delete();
      setState(() {
        _records.removeWhere((record) => record['id'] == recordId);
      });
    } catch (e) {
      print('Error deleting record: $e');
    }
  }

  void _editRecord(Map<String, dynamic> record) {
    // Create TextEditingControllers for each field, pre-populated with existing values.
    TextEditingController dateController =
        TextEditingController(text: record['date']);
    TextEditingController stepCountController =
        TextEditingController(text: record['stepCount'].toString());
    TextEditingController caloriesBurnedController =
        TextEditingController(text: record['caloriesBurned'].toString());
    TextEditingController heightController =
        TextEditingController(text: record['height'].toString());
    TextEditingController weightController =
        TextEditingController(text: record['weight'].toString());
    TextEditingController bodyFatController =
        TextEditingController(text: record['bodyFat'].toString());
    TextEditingController bmiController =
        TextEditingController(text: record['bmi'].toString());
    TextEditingController heartRateController =
        TextEditingController(text: record['heartRate'].toString());
    TextEditingController bloodPressureController =
        TextEditingController(text: record['bloodPressure']);
    TextEditingController sleepDurationController =
        TextEditingController(text: record['sleepDuration'].toString());

    // Open the dialog for editing the record.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Record'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(labelText: 'Date'),
                ),
                TextField(
                  controller: stepCountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Step Count'),
                ),
                TextField(
                  controller: caloriesBurnedController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Calories Burned'),
                ),
                TextField(
                  controller: heightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Height (cm)'),
                ),
                TextField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Weight (kg)'),
                ),
                TextField(
                  controller: bodyFatController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Body Fat (%)'),
                ),
                TextField(
                  controller: bmiController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'BMI'),
                ),
                TextField(
                  controller: heartRateController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Heart Rate (bpm)'),
                ),
                TextField(
                  controller: bloodPressureController,
                  decoration: InputDecoration(labelText: 'Blood Pressure'),
                ),
                TextField(
                  controller: sleepDurationController,
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(labelText: 'Sleep Duration (hrs)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Ensure correct data parsing for each field before saving
                try {
                  // Update the record in Firestore
                  FirebaseFirestore.instance
                      .collection('FitnessTracker')
                      .doc(_userId)
                      .collection('records')
                      .doc(record['id'])
                      .update({
                    'date': dateController.text,
                    'stepCount': int.parse(
                        stepCountController.text), // Ensure parsing to int
                    'caloriesBurned': int.parse(
                        caloriesBurnedController.text), // Ensure parsing to int
                    'height': int.parse(
                        heightController.text), // Ensure parsing to int
                    'weight': int.parse(
                        weightController.text), // Ensure parsing to int
                    'bodyFat': double.parse(
                        bodyFatController.text), // Ensure parsing to double
                    'bmi': double.parse(
                        bmiController.text), // Ensure parsing to double
                    'heartRate': int.parse(
                        heartRateController.text), // Ensure parsing to int
                    'bloodPressure': bloodPressureController.text,
                    'sleepDuration': double.parse(sleepDurationController
                        .text), // Ensure parsing to double
                  });
                  setState(() {
                    // Update the record locally with the new values
                    record['date'] = dateController.text;
                    record['stepCount'] = int.parse(stepCountController.text);
                    record['caloriesBurned'] =
                        int.parse(caloriesBurnedController.text);
                    record['height'] = int.parse(heightController.text);
                    record['weight'] = int.parse(weightController.text);
                    record['bodyFat'] = double.parse(bodyFatController.text);
                    record['bmi'] = double.parse(bmiController.text);
                    record['heartRate'] = int.parse(heartRateController.text);
                    record['bloodPressure'] = bloodPressureController.text;
                    record['sleepDuration'] =
                        double.parse(sleepDurationController.text);
                  });
                  Navigator.pop(context); // Close the dialog
                } catch (e) {
                  // Show error message if something goes wrong
                  print('Error saving data: $e');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Error saving record. Please check your inputs.')));
                }
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Records'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: _records.isEmpty
          ? const Center(
              child: Text('No records available.',
                  style: TextStyle(fontSize: 18, color: Colors.grey)))
          : ListView.builder(
              itemCount: _records.length,
              itemBuilder: (context, index) {
                final record = _records[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date: ${record['date']}',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal),
                        ),
                        const SizedBox(height: 10),
                        _buildRecordRow(
                            'Steps:',
                            record['stepCount'].toString(),
                            Icons.directions_walk),
                        _buildRecordRow(
                            'Calories Burned:',
                            record['caloriesBurned'].toString(),
                            Icons.local_fire_department),
                        _buildRecordRow(
                            'Height:', '${record['height']} cm', Icons.height),
                        _buildRecordRow('Weight:', '${record['weight']} kg',
                            Icons.monitor_weight),
                        _buildRecordRow('BMI:', record['bmi'].toString(),
                            Icons.health_and_safety),
                        _buildRecordRow('Body Fat:', '${record['bodyFat']}%',
                            Icons.assessment),
                        _buildRecordRow('Heart Rate:',
                            '${record['heartRate']} bpm', Icons.favorite),
                        _buildRecordRow('Blood Pressure:',
                            record['bloodPressure'], Icons.medical_services),
                        _buildRecordRow(
                            'Sleep Duration:',
                            '${record['sleepDuration']} hrs',
                            Icons.nightlight_round),
                        // Add Edit and Delete buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.teal),
                              onPressed: () => _editRecord(record),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteRecord(record['id']),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildRecordRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal, size: 28),
        const SizedBox(width: 10),
        Text(
          '$label $value',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
