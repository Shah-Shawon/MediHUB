import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:medibd/homepage.dart';

void main() {
  runApp(const AmbulanceApp());
}

class AmbulanceApp extends StatelessWidget {
  const AmbulanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ambulance App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const AmbulanceListPage(),
    );
  }
}

class Ambulance {
  final String district;
  final String ambulanceNumber;

  Ambulance({
    required this.district,
    required this.ambulanceNumber,
  });

  factory Ambulance.fromJson(Map<String, dynamic> json) {
    return Ambulance(
      district: json['district'],
      ambulanceNumber: json['ambulance_number'],
    );
  }
}

class AmbulanceListPage extends StatefulWidget {
  const AmbulanceListPage({super.key});

  @override
  _AmbulanceListPageState createState() => _AmbulanceListPageState();
}

class _AmbulanceListPageState extends State<AmbulanceListPage> {
  List<Ambulance> _ambulances = [];
  List<Ambulance> _filteredAmbulances = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAmbulances();
  }

  Future<void> _fetchAmbulances() async {
    final response = await http
        .get(Uri.parse('https://shah-shawon.github.io/ambulanceNumber.json'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['ambulances'];
      setState(() {
        _ambulances = jsonData.map((json) => Ambulance.fromJson(json)).toList();
        _filteredAmbulances = _ambulances;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load ambulances');
    }
  }

  void _filterAmbulances(String query) {
    setState(() {
      _filteredAmbulances = _ambulances.where((ambulance) {
        return ambulance.district.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
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
            leading: IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                // Navigate to the homepage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            title: TextField(
              onChanged: _filterAmbulances,
              decoration: const InputDecoration(
                hintText: 'Search by district',
                hintStyle: TextStyle(color: Color.fromARGB(137, 255, 255, 255)),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _filteredAmbulances.length,
              itemBuilder: (context, index) {
                final ambulance = _filteredAmbulances[index];
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
                      ambulance.district,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      'Ambulance Number: ${ambulance.ambulanceNumber}',
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
                        // You can navigate to a detailed page if needed
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         AmbulanceDetailPage(ambulance: ambulance),
                        //   ),
                        // );
                      },
                      child: const Text('More'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
