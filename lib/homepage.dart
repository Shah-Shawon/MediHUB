import 'package:flutter/material.dart';
import 'package:medibd/FitnessTrackerApp/FitnessTrackerApp.dart';
import 'package:medibd/ambulanceNum.dart';

import 'package:medibd/bloodDonor.dart';
import 'package:medibd/bmiCalculate.dart';
import 'package:medibd/doctorList.dart';
import 'package:medibd/drawer/drawer.dart';
import 'package:medibd/drugdictionary.dart';
import 'package:medibd/hospital.dart';
import 'package:medibd/pharmacyList.dart';
import 'package:medibd/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Search query controller
  TextEditingController _searchController = TextEditingController();

  // List of all services
  final List<ServiceTile> allServiceTiles = [
    const ServiceTile(
      icon: Icons.local_hospital,
      title: 'Medicine Dictionary',
      page: MedicineApp(),
    ),
    const ServiceTile(
      icon: Icons.calculate,
      title: 'BMI Calculator',
      page: BMICalculatorApp(),
    ),
    const ServiceTile(
      icon: Icons.fitness_center, // Icon representing fitness
      title: 'Fitness Tracker', // Title for the fitness tracker
      page:
          FitnessTrackerApp(), // Page to navigate to for fitness tracker feature
    ),
    const ServiceTile(
      icon: Icons.person_search,
      title: 'Doctor List',
      page: DoctorApp(),
    ),
    const ServiceTile(
      icon: Icons.phone,
      title: 'Ambulance Number',
      page: AmbulanceApp(),
    ),
    const ServiceTile(
      icon: Icons.store_mall_directory,
      title: 'Nearest Pharmacy',
      page: PharmacyApp(),
    ),
    const ServiceTile(
      icon: Icons.local_hospital,
      title: 'Nearest Hospital',
      page: HospitalListScreen(),
    ),
    const ServiceTile(
      icon: Icons.bloodtype,
      title: 'Blood Donor',
      page: BloodDonorApp(),
    ),
    const ServiceTile(
      icon: Icons.health_and_safety,
      title: 'Symptoms of Disease',
      page: SymptomsScreen(),
    ),
  ];

  // Filtered service list based on search
  List<ServiceTile> filteredServiceTiles = [];

  @override
  void initState() {
    super.initState();
    // Initially show all services
    filteredServiceTiles = allServiceTiles;
    // Add listener for search input
    _searchController.addListener(_filterServices);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Function to filter services based on search query
  void _filterServices() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredServiceTiles = allServiceTiles
          .where((tile) => tile.title.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health App'),
        backgroundColor: Colors.teal,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Container(
              width: 200,
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search Services...',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D5C75), // Dark teal
              Color(0xFF2A93B4), // Lighter blue
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Always 2 items per row
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: filteredServiceTiles.length,
            itemBuilder: (context, index) {
              return filteredServiceTiles[index];
            },
          ),
        ),
      ),
    );
  }
}

class ServiceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget page;

  const ServiceTile({
    super.key,
    required this.icon,
    required this.title,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      borderRadius: BorderRadius.circular(10.0),
      splashColor: Colors.blue.withOpacity(0.3),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Semantics(
              label: title,
              child: Icon(
                icon,
                size: 40.0,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class BloodDonorScreen extends StatelessWidget {
  const BloodDonorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Donor Service'),
      ),
      body: const Center(
        child: Text(
          'Blood Donor Screen',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class SymptomsScreen extends StatelessWidget {
  const SymptomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Symptoms of Disease'),
      ),
      body: const Center(
        child: Text(
          'Symptoms of Disease Screen',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
