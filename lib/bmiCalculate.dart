import 'package:flutter/material.dart';
import 'package:medibd/homepage.dart';

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const BMICalculator(),
    );
  }
}

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key});

  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  final TextEditingController _feetController = TextEditingController();
  final TextEditingController _inchesController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String _result = "";
  String _suggestion = "";

  void calculateBMI() {
    double weight = double.tryParse(_weightController.text) ?? 0.0;
    int feet = int.tryParse(_feetController.text) ?? 0;
    int inches = int.tryParse(_inchesController.text) ?? 0;

    // Convert height in feet and inches to height in meters
    double heightInMeters = ((feet * 12) + inches) * 0.0254;

    if (heightInMeters > 0 && weight > 0) {
      double bmi = weight / (heightInMeters * heightInMeters);
      setState(() {
        _result = "Your BMI is ${bmi.toStringAsFixed(1)}";
        _suggestion = _getBMISuggestion(bmi);
      });
    } else {
      setState(() {
        _result = "Please enter valid height and weight.";
        _suggestion = "";
      });
    }
  }

  String _getBMISuggestion(double bmi) {
    if (bmi < 18.5) {
      return "অধিক কম ওজন: আপনি যে খাদ্য গ্রহণ করেন তা সুষম হতে হবে। সুস্থ থাকার জন্য পুষ্টিকর খাবার খাওয়া উচিত।";
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return "স্বাভাবিক ওজন: ভাল কাজ করছেন! স্বাস্থ্যকর জীবনযাত্রা বজায় রাখুন।";
    } else if (bmi >= 25 && bmi < 29.9) {
      return "অতিরিক্ত ওজন: সুস্থ জীবনযাত্রা বজায় রাখার জন্য স্বাস্থ্যকর খাবার এবং নিয়মিত ব্যায়াম করুন।";
    } else {
      return "মোটা: দয়া করে একজন স্বাস্থ্য পেশাদারের সাথে পরামর্শ করুন এবং স্বাস্থ্যকর জীবনযাপন শুরু করুন।";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            // Navigate back to home page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
      ),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Enter your height:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _feetController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Feet',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white, // Background of text field
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _inchesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Inches',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white, // Background of text field
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Enter your weight (kg):',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Weight in kg',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white, // Background of text field
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: calculateBMI,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Calculate BMI'),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  _result,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  _suggestion,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
