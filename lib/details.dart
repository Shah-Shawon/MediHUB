import 'package:flutter/material.dart';
import 'package:medibd/drugdictionary.dart';
class MedicineDetailPage extends StatelessWidget {
  final Medicine medicine;

  const MedicineDetailPage({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(medicine.name),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category
            Row(
              children: [
                const Icon(Icons.category, color: Colors.teal, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Category: ${medicine.category}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1.5),

            // Description
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.description, color: Colors.teal, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Description: ${medicine.description}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1.5),

            // Dosage
            Row(
              children: [
                const Icon(Icons.medical_services,
                    color: Colors.teal, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Dosage: ${medicine.dosage}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1.5),

            // Instructions
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: Colors.teal, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Instructions: ${medicine.instructions}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1.5),

            // Side Effects
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: Colors.red, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Side Effects: ${medicine.sideEffects.join(', ')}',
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1.5),

            // Alternatives
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.swap_horiz, color: Colors.blue, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Alternatives: ${medicine.alternatives.join(', ')}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1.5),

            // Recommended Age
            Row(
              children: [
                const Icon(Icons.person, color: Colors.purple, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Recommended Age: ${medicine.age}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
