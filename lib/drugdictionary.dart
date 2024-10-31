import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:medibd/details.dart';

void main() {
  runApp(const MedicineApp());
}

class MedicineApp extends StatelessWidget {
  const MedicineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medicine App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MedicineListPage(),
    );
  }
}

class Medicine {
  final int id;
  final String name;
  final String category;
  final String description;
  final String dosage;
  final String instructions;
  final List<String> sideEffects;
  final List<String> alternatives;
  final String age;

  Medicine({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.dosage,
    required this.instructions,
    required this.sideEffects,
    required this.alternatives,
    required this.age,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      dosage: json['usage']['dosage'],
      instructions: json['usage']['instructions'],
      sideEffects: List<String>.from(json['side_effects']),
      alternatives: List<String>.from(json['alternatives']),
      age: json['age'],
    );
  }
}

class MedicineListPage extends StatefulWidget {
  const MedicineListPage({super.key});

  @override
  _MedicineListPageState createState() => _MedicineListPageState();
}

class _MedicineListPageState extends State<MedicineListPage> {
  List<Medicine> _medicines = [];
  List<Medicine> _filteredMedicines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMedicines();
  }

  Future<void> _fetchMedicines() async {
    final response =
        await http.get(Uri.parse('https://shah-shawon.github.io/medicin.json'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['medicines'];
      setState(() {
        _medicines = jsonData.map((json) => Medicine.fromJson(json)).toList();
        _filteredMedicines = _medicines;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load medicines');
    }
  }

  void _filterMedicines(String query) {
    setState(() {
      _filteredMedicines = _medicines.where((medicine) {
        return medicine.name.toLowerCase().contains(query.toLowerCase()) ||
            medicine.category.toLowerCase().contains(query.toLowerCase());
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
              onChanged: _filterMedicines,
              decoration: const InputDecoration(
                hintText: 'Search by name or category',
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
              itemCount: _filteredMedicines.length,
              itemBuilder: (context, index) {
                final medicine = _filteredMedicines[index];
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
                      medicine.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      'Category: ${medicine.category}',
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
                                MedicineDetailPage(medicine: medicine),
                          ),
                        );
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
