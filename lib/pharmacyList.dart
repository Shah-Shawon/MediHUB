import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const PharmacyApp());
}

class Pharmacy {
  final String name;
  final String address;
  final String phone;

  Pharmacy({
    required this.name,
    required this.address,
    required this.phone,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
    );
  }
}

class PharmacyApp extends StatelessWidget {
  const PharmacyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pharmacy App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const PharmacyListPage(),
    );
  }
}

class PharmacyListPage extends StatefulWidget {
  const PharmacyListPage({super.key});

  @override
  _PharmacyListPageState createState() => _PharmacyListPageState();
}

class _PharmacyListPageState extends State<PharmacyListPage> {
  List<Pharmacy> _pharmacies = [];
  List<Pharmacy> _filteredPharmacies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPharmacies();
  }

  Future<void> _fetchPharmacies() async {
    try {
      final response = await http.get(
        Uri.parse('https://shah-shawon.github.io/pharmacyList.json'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> pharmaciesJson = jsonData['pharmacies'];

        setState(() {
          _pharmacies =
              pharmaciesJson.map((json) => Pharmacy.fromJson(json)).toList();
          _filteredPharmacies = _pharmacies;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load pharmacies');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      // Optionally, handle the error with a dialog or a message on the UI.
    }
  }

  void _filterPharmacies(String query) {
    setState(() {
      _filteredPharmacies = _pharmacies.where((pharmacy) {
        return pharmacy.name.toLowerCase().contains(query.toLowerCase()) ||
            pharmacy.address.toLowerCase().contains(query.toLowerCase());
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
            title: TextField(
              onChanged: _filterPharmacies,
              decoration: const InputDecoration(
                hintText: 'Search by name or address',
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
              itemCount: _filteredPharmacies.length,
              itemBuilder: (context, index) {
                final pharmacy = _filteredPharmacies[index];
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
                        Icons.local_pharmacy,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      pharmacy.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      'Address: ${pharmacy.address}',
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
                        // Handle "More" button press, possibly navigate to details page
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
