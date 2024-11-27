import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:medibd/homepage.dart'; // Import the Home page file

void main() {
  runApp(const DoctorApp());
}

class DoctorApp extends StatelessWidget {
  const DoctorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const DoctorListPage(),
    );
  }
}

class Doctor {
  final String name;
  final String fieldOfInterest;
  final String chamber;
  final String visitTime;
  final String phone;

  Doctor({
    required this.name,
    required this.fieldOfInterest,
    required this.chamber,
    required this.visitTime,
    required this.phone,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      name: json['name'],
      fieldOfInterest: json['field_of_interest'],
      chamber: json['chamber'],
      visitTime: json['visit_time'],
      phone: json['phone'],
    );
  }
}

class DoctorListPage extends StatefulWidget {
  const DoctorListPage({super.key});

  @override
  _DoctorListPageState createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  List<Doctor> _doctors = [];
  List<Doctor> _filteredDoctors = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
    final response = await http
        .get(Uri.parse('https://shah-shawon.github.io/doctorList.json'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['doctors'];
      setState(() {
        _doctors = jsonData.map((json) => Doctor.fromJson(json)).toList();
        _filteredDoctors = _doctors;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load doctors');
    }
  }

  void _filterDoctors() {
    setState(() {
      _filteredDoctors = _doctors.where((doctor) {
        return doctor.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            doctor.fieldOfInterest
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF009688), Color(0xFF004D40)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (query) {
                      setState(() {
                        _searchQuery = query;
                      });
                      _filterDoctors();
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search by name and speciality',
                      hintStyle:
                          TextStyle(color: Color.fromARGB(137, 255, 255, 255)),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            leading: IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _filteredDoctors.length,
              itemBuilder: (context, index) {
                final doctor = _filteredDoctors[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.tealAccent.shade700,
                      child: const Icon(
                        Icons.local_hospital,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      doctor.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      'Specialty: ${doctor.fieldOfInterest}\nChamber: ${doctor.chamber}',
                      style: TextStyle(color: Colors.teal.shade700),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 130, 221, 210),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DoctorDetailsPage(doctor: doctor),
                          ),
                        );
                      },
                      child: const Text('Details'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class DoctorDetailsPage extends StatelessWidget {
  final Doctor doctor;
  const DoctorDetailsPage({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(doctor.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Field of Interest: ${doctor.fieldOfInterest}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Chamber: ${doctor.chamber}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Visit Time: ${doctor.visitTime}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Phone: ${doctor.phone}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle phone call or other actions
              },
              child: const Text('Call Doctor'),
            ),
          ],
        ),
      ),
    );
  }
}
