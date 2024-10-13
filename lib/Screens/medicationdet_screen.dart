import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore integration
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication
import 'package:intl/intl.dart'; // For date formatting
import 'done_splash_screen.dart'; // Import the DoneSplashScreen

class MedicationDetailsScreen extends StatefulWidget {
  final String medicationId; // Accept medication ID as a parameter

  const MedicationDetailsScreen({super.key, required this.medicationId});

  @override
  _MedicationDetailsScreenState createState() => _MedicationDetailsScreenState();
}

class _MedicationDetailsScreenState extends State<MedicationDetailsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
  Map<String, dynamic>? medicationDetails; // To hold the medication details

  @override
  void initState() {
    super.initState();
    _fetchMedicationDetails(); // Fetch the medication details when the screen is initialized
  }

  Future<void> _fetchMedicationDetails() async {
    String userId = FirebaseAuth.instance.currentUser!.uid; // Get the logged-in user's UID

    try {
      DocumentSnapshot doc = await _firestore.collection('medications')
          .doc(widget.medicationId) // Fetch the medication document by ID
          .get();

      if (doc.exists) {
        setState(() {
          medicationDetails = doc.data() as Map<String, dynamic>?; // Set the medication details
        });
      } else {
        // Handle the case where the document does not exist
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Medication not found.')));
      }
    } catch (e) {
      // Handle errors appropriately
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching medication details: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator while fetching the medication details
    if (medicationDetails == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Calculate progress
    double progress = 0.0;
    int progressCount = medicationDetails!['progress_count'] ?? 0;
    int totalDosages = medicationDetails!['total_dosages'] ?? 1; // Avoid division by zero
    if (totalDosages > 0) {
      progress = progressCount / totalDosages;
    }

    // Medication details UI
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Medication Name',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      medicationDetails!['medication_name'] ?? 'N/A',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const Divider(height: 20, thickness: 1),
                    Text(
                      'Dosage',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${medicationDetails!['dosage']?['value'] ?? 'N/A'} ${medicationDetails!['dosage']?['unit'] ?? 'N/A'}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const Divider(height: 20, thickness: 1),
                    Text(
                      'Schedule',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _formatSchedule(medicationDetails!['schedule']),
                      style: const TextStyle(fontSize: 20),
                    ),
                    const Divider(height: 20, thickness: 1),
                    Text(
                      'Total Dosage',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$totalDosages',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const Divider(height: 20, thickness: 1),
                    Text(
                      'Progress Count',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$progressCount',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const Divider(height: 20, thickness: 1),
                    Text(
                      'Progress Line',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    const SizedBox(height: 5),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey,
                      color: Colors.blue,
                      minHeight: 10,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$progressCount / $totalDosages',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const Divider(height: 20, thickness: 1),
                    Text(
                      'Notes',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      medicationDetails!['notes'] ?? 'N/A',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    // This is where you could implement the functionality to skip or mark as done, if needed
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatSchedule(List<dynamic>? schedule) {
    if (schedule == null) {
      return 'N/A';
    }
    return schedule.map((s) {
      if (s['timestamp'] != null && s['timestamp'] is Timestamp) {
        return DateFormat('yyyy-MM-dd HH:mm').format((s['timestamp'] as Timestamp).toDate());
      } else {
        return 'Invalid date';
      }
    }).join(', ');
  }
}
