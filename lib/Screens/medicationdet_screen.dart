import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore integration
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication
import 'package:intl/intl.dart'; // For date formatting

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
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Medication not found.')));
      }
    } catch (e) {
      // Handle errors appropriately
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching medication details: $e')));
    }
  }

  // Delete the medication
  Future<void> _deleteMedication() async {
    try {
      await _firestore.collection('medications').doc(widget.medicationId).delete();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Medication deleted.')));
      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting medication: $e')));
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
        title: const Text('Medication Details', style: TextStyle(fontFamily: 'Pacifico')),
        backgroundColor: const Color(0xFF6936F5), // Updated background color
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
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6936F5), fontFamily: 'Pacifico'),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      medicationDetails!['medicine'] ?? 'N/A', // Access the medicine field
                      style: const TextStyle(fontSize: 20, fontFamily: 'Pacifico'),
                    ),
                    const Divider(height: 20, thickness: 1),
                    Text(
                      'Dosage',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6936F5), fontFamily: 'Pacifico'),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${medicationDetails!['dosage']?['value'] ?? 'N/A'} ${medicationDetails!['dosage']?['unit'] ?? 'N/A'}',
                      style: const TextStyle(fontSize: 20, fontFamily: 'Pacifico'),
                    ),
                    const Divider(height: 20, thickness: 1),
                    Text(
                      'Schedule',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6936F5), fontFamily: 'Pacifico'),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _formatSchedule(medicationDetails!['schedule']),
                      style: const TextStyle(fontSize: 20, fontFamily: 'Pacifico'),
                    ),
                    const Divider(height: 20, thickness: 1),
                    Text(
                      'Total Dosage',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6936F5), fontFamily: 'Pacifico'),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${medicationDetails!['total_dosages'] ?? 0}',
                      style: const TextStyle(fontSize: 20, fontFamily: 'Pacifico'),
                    ),
                    const Divider(height: 20, thickness: 1),
                    Text(
                      'Progress Count',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6936F5), fontFamily: 'Pacifico'),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$progressCount',
                      style: const TextStyle(fontSize: 20, fontFamily: 'Pacifico'),
                    ),
                    const Divider(height: 20, thickness: 1),
                    Text(
                      'Progress Line',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6936F5), fontFamily: 'Pacifico'),
                    ),
                    const SizedBox(height: 5),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey,
                      color: const Color(0xFF6936F5),
                      minHeight: 10,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$progressCount / $totalDosages',
                      style: const TextStyle(fontSize: 20, fontFamily: 'Pacifico'),
                    ),
                    const Divider(height: 20, thickness: 1),
                    const Text(
                      'Notes',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6936F5), fontFamily: 'Pacifico'),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      medicationDetails!['notes'] ?? 'N/A',
                      style: const TextStyle(fontSize: 20, fontFamily: 'Pacifico'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _deleteMedication,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Delete button color
                      ),
                      child: const Text('Delete Medication', style: TextStyle(fontFamily: 'Pacifico')),
                    ),
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
    if (schedule == null || schedule.isEmpty) {
      return 'N/A';
    }

    return schedule.map((s) {
      if (s['alarm_trigger_time'] != null && s['alarm_trigger_time'] is Timestamp) {
        String time = DateFormat('hh:mm a').format((s['alarm_trigger_time'] as Timestamp).toDate());
        return 'Alarm at $time'; // Show alarm time only
      } else {
        return 'Invalid time';
      }
    }).toList().join(', ');
  }
}
