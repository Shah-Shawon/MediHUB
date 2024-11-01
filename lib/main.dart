import 'package:flutter/material.dart';
import 'package:medibd/appbar.dart';
import 'package:medibd/bmiCalculate.dart';
import 'package:medibd/drawer.dart';
import 'package:medibd/drugdictionary.dart';
import 'package:medibd/hospital.dart';
import 'package:medibd/splash_screen.dart';

void main() {
  runApp(MyApp());
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
      home: SplashScreen(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Container(
        decoration: BoxDecoration(
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
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            children: <Widget>[
              ServiceTile(
                icon: Icons.local_hospital,
                title: 'Medicine Dictionary',
                page: const MedicineApp(),
              ),
              ServiceTile(
                icon: Icons.calculate,
                title: 'BMI Calculator',
                page: BMICalculatorApp(),
              ),
              ServiceTile(
                icon: Icons.person_search,
                title: 'Doctor List',
                page: const MedicineApp(),
              ),
              ServiceTile(
                icon: Icons.phone,
                title: 'Ambulance Number',
                page: const MedicineApp(),
              ),
              ServiceTile(
                icon: Icons.store_mall_directory,
                title: 'Nearest Pharmacy',
                page: const MedicineApp(),
              ),
              ServiceTile(
                icon: Icons.local_hospital,
                title: 'Nearest Hospital',
                page: HospitalListScreen(),
              ),
            ],
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 40.0,
              color: Colors.blue,
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
