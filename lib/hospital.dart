import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medibd/homepage.dart';
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
              children: [
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.white),
                  onPressed: () {
                    // Navigate to the home screen (or handle your own navigation)
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (query) {
                      _filterHospitals();
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search by division or hospital name',
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
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _filteredHospitals.length,
              itemBuilder: (context, index) {
                final hospital = _filteredHospitals[index];
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
                      hospital.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      'Phone: ${hospital.phone}\nDivision: ${hospital.division}',
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
                                HospitalDetailScreen(hospital: hospital),
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
        title: Text(hospital.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Division: ${hospital.division}',
                style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 20),
            Text('Phone: ${hospital.phone}',
                style: const TextStyle(fontSize: 20)),
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
