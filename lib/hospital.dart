import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hospital List',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const HospitalListScreen(),
    );
  }
}

class Hospital {
  final String name;
  final String phone;
  final String openingTime;
  final String division;

  Hospital({
    required this.name,
    required this.phone,
    required this.openingTime,
    required this.division,
  });

  factory Hospital.fromJson(Map<String, dynamic> json, String division) {
    return Hospital(
      name: json['name'],
      phone: json['phone'],
      openingTime: json['opening_time'],
      division: division,
    );
  }
}

class HospitalListScreen extends StatefulWidget {
  const HospitalListScreen({super.key});

  @override
  _HospitalListScreenState createState() => _HospitalListScreenState();
}

class _HospitalListScreenState extends State<HospitalListScreen> {
  List<Hospital> _hospitals = [];
  List<Hospital> _filteredHospitals = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchHospitals();
    _searchController.addListener(_filterHospitals);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchHospitals() async {
    final response = await http
        .get(Uri.parse('https://shah-shawon.github.io/hospital.json'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> divisions = data['divisions'];
      List<Hospital> hospitals = [];

      for (var division in divisions) {
        for (var hospital in division['hospitals']) {
          hospitals.add(Hospital.fromJson(hospital, division['name']));
        }
      }

      setState(() {
        _hospitals = hospitals;
        _filteredHospitals = hospitals;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load hospitals');
    }
  }

  void _filterHospitals() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredHospitals = _hospitals.where((hospital) {
        return hospital.name.toLowerCase().contains(query) ||
            hospital.division.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search by division or hospital name',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white60),
            icon: Icon(Icons.search, color: Colors.white),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal[700]!, Colors.teal[400]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _filteredHospitals.length,
              itemBuilder: (context, index) {
                final hospital = _filteredHospitals[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  elevation: 5,
                  child: ListTile(
                    title: Text(hospital.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text(hospital.phone,
                        style: TextStyle(color: Colors.grey[600])),
                    trailing: const Icon(Icons.chevron_right, color: Colors.teal),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HospitalDetailScreen(hospital: hospital),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class HospitalDetailScreen extends StatelessWidget {
  final Hospital hospital;

  const HospitalDetailScreen({super.key, required this.hospital});

  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hospital.name, style: const TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal[700]!, Colors.teal[400]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Division: ${hospital.division}',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800]),
            ),
            const SizedBox(height: 20),
            Text('Phone: ${hospital.phone}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('Opening Time: ${hospital.openingTime}',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => _makePhoneCall(hospital.phone),
              icon: const Icon(Icons.call),
              label: const Text('Call Now'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
