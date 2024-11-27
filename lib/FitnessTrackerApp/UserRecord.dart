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
      appBar: AppBar(
        title: const Text('View Records'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: _records.isEmpty
          ? const Center(child: Text('No records available.', style: TextStyle(fontSize: 18, color: Colors.grey)))
          : ListView.builder(
              itemCount: _records.length,
              itemBuilder: (context, index) {
                final record = _records[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                        ),
                        const SizedBox(height: 10),
                        _buildRecordRow('Steps:', record['stepCount'].toString(), Icons.directions_walk),
                        _buildRecordRow('Calories Burned:', record['caloriesBurned'].toString(), Icons.local_fire_department),
                        _buildRecordRow('Height:', '${record['height']} cm', Icons.height),
                        _buildRecordRow('Weight:', '${record['weight']} kg', Icons.monitor_weight),
                        _buildRecordRow('BMI:', record['bmi'].toString(), Icons.health_and_safety),
                        _buildRecordRow('Body Fat:', '${record['bodyFat']}%', Icons.assessment),
                        _buildRecordRow('Heart Rate:', '${record['heartRate']} bpm', Icons.favorite),
                        _buildRecordRow('Blood Pressure:', record['bloodPressure'], Icons.medical_services),
                        _buildRecordRow('Sleep Duration:', '${record['sleepDuration']} hrs', Icons.nightlight_round),
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
