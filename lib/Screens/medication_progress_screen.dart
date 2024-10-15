import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'done_splash_screen.dart';

class MedicationProgressScreen extends StatelessWidget {
  final String medicationId; // Pass the medication ID to fetch details

  const MedicationProgressScreen({super.key, required this.medicationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Progress'),
        backgroundColor: Color(0xFF6936F5), // Set AppBar color
      ),
      backgroundColor: Color(0xFF6936F5), // Set background color
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('medications')
            .doc(medicationId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No medication found.'));
          }

          final medicationData = snapshot.data!.data() as Map<String, dynamic>;
          final medicationName = medicationData['medicine'] ?? 'Unknown';
          final dosage = medicationData['dosage'] ?? 0; // Fetch dosage from Firestore
          final notes = medicationData['notes'] ?? 'No notes available'; // Fetch notes from Firestore
          final progressCount = medicationData['progress_field'] ?? 0; // Fetch progress from Firestore

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Medication Name: $medicationName',
                  style: TextStyle(fontSize: 24, fontFamily: 'Pacifico', color: Colors.white),
                ),
                SizedBox(height: 16),
                Text(
                  'Dosage: $dosage mg',
                  style: TextStyle(fontSize: 20, fontFamily: 'Pacifico', color: Colors.white),
                ),
                SizedBox(height: 16),
                Text(
                  'Progress: $progressCount doses taken',
                  style: TextStyle(fontSize: 20, fontFamily: 'Pacifico', color: Colors.white),
                ),
                SizedBox(height: 16),
                Text(
                  'Notes: $notes',
                  style: TextStyle(fontSize: 16, fontFamily: 'Pacifico', color: Colors.white),
                ),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Color for the Skip button
                      ),
                      onPressed: () {
                        // Skip logic
                        updateMedicationStatus(medicationId, 'not taken', dosage);
                        Navigator.pop(context); // Go back to the previous screen
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(fontFamily: 'Pacifico'),
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Color for the Done button
                      ),
                      onPressed: () {
                        // Done logic
                        updateMedicationStatus(medicationId, 'taken', dosage);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SplashScreen()),
                        );
                      },
                      child: const Text(
                        'Done',
                        style: TextStyle(fontFamily: 'Pacifico'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> updateMedicationStatus(String medicationId, String status, int dosage) async {
    await FirebaseFirestore.instance
        .collection('medications')
        .doc(medicationId)
        .update({
      'scheduled_status': status,
      'progress_field': FieldValue.increment(dosage), // Increment progress field by dosage
    });
  }
}
