import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:medibd/homepage.dart';

void main() {
  runApp(const BloodDonorApp());
}

class BloodDonorApp extends StatelessWidget {
  const BloodDonorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Donor App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: const BloodDonorListPage(),
    );
  }
}

class BloodDonor {
  final String name;
  final String address;
  final String phone;
  final String lastDonate;
  final String bloodGroup;
  final String nextAvailableDonationDate;
  final String availability;

  BloodDonor({
    required this.name,
    required this.address,
    required this.phone,
    required this.lastDonate,
    required this.bloodGroup,
    required this.nextAvailableDonationDate,
    required this.availability,
  });

  factory BloodDonor.fromJson(Map<String, dynamic> json) {
    return BloodDonor(
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      lastDonate: json['last_donate'],
      bloodGroup: json['blood_group'],
      nextAvailableDonationDate: json['next_available_donation_date'],
      availability: json['availability'],
    );
  }
}

class BloodDonorListPage extends StatefulWidget {
  const BloodDonorListPage({super.key});

  @override
  _BloodDonorListPageState createState() => _BloodDonorListPageState();
}

class _BloodDonorListPageState extends State<BloodDonorListPage> {
  List<BloodDonor> _donors = [];
  List<BloodDonor> _filteredDonors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDonors();
  }

  Future<void> _fetchDonors() async {
    final response = await http.get(
      Uri.parse('https://shah-shawon.github.io/bloodDonor.json'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        _donors = jsonData.map((json) => BloodDonor.fromJson(json)).toList();
        _filteredDonors = _donors;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load blood donors');
    }
  }

  void _filterDonors(String query) {
    setState(() {
      _filteredDonors = _donors.where((donor) {
        return donor.name.toLowerCase().contains(query.toLowerCase()) ||
            donor.bloodGroup.toLowerCase().contains(query.toLowerCase());
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
              colors: [Color(0xFF009688), Color(0xFF004D40)], // Teal gradient
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
            title: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    onChanged: _filterDonors,
                    decoration: const InputDecoration(
                      hintText: 'Search by name or blood group',
                      hintStyle: TextStyle(color: Colors.white70),
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
              itemCount: _filteredDonors.length,
              itemBuilder: (context, index) {
                final donor = _filteredDonors[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: donor.availability == 'Yes'
                          ? Colors.green[300] // Green for available donors
                          : Colors.red[300], // Red for unavailable
                      child: const Icon(
                        Icons.bloodtype,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      donor.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      'Blood Group: ${donor.bloodGroup}\nLast Donated: ${donor.lastDonate}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.tealAccent, // Teal button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BloodDonorDetailPage(donor: donor),
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

class BloodDonorDetailPage extends StatelessWidget {
  final BloodDonor donor;

  const BloodDonorDetailPage({super.key, required this.donor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donor Details: ${donor.name}'),
        backgroundColor: const Color(0xFF009688), // Teal color for the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${donor.name}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text('Blood Group: ${donor.bloodGroup}'),
            Text('Last Donated: ${donor.lastDonate}'),
            Text('Next Available: ${donor.nextAvailableDonationDate}'),
            Text('Address: ${donor.address}'),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Teal button color
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                // Custom action, e.g., call donor
              },
              child: Text('Contact ${donor.phone}'),
            ),
          ],
        ),
      ),
    );
  }
}
