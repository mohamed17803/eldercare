import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmergencyCallsScreen extends StatefulWidget {
  const EmergencyCallsScreen({super.key});

  @override
  _EmergencyCallsScreenState createState() => _EmergencyCallsScreenState();
}
class _EmergencyCallsScreenState extends State<EmergencyCallsScreen> {
  String emergencyContactNumber = '';
  bool isCalling = false; // Track if a call is in progress

  @override
  void initState() {
    super.initState();
    _fetchEmergencyContact();
  }

  Future<void> _fetchEmergencyContact() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // Exit if user is not authenticated

    // Fetch the emergency contact number for the user from Firestore
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('emergency_contacts')
          .where('user_id', isEqualTo: user.uid) // Fetch contact for the logged-in user
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        emergencyContactNumber = snapshot.docs.first['contact_number'];
        // Set isCalling to true to indicate that a call is being handled
        setState(() {
          isCalling = true;
        });
      } else {
        print('No emergency contact found for this user.');
      }
    } catch (e) {
      print("Error fetching emergency contact: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6936F5), // Same background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Emergency Call Status',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 30,
                color: Colors.white, // Same font color
              ),
            ),
            const SizedBox(height: 20),
            if (isCalling) ...[
              Text(
                'Calling $emergencyContactNumber...',
                style: const TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 20,
                  color: Colors.white, // Same font color
                ),
              ),
            ] else ...[
              const Text(
                'No emergency contact found.',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 20,
                  color: Colors.white, // Same font color
                ),
              ),
            ],
            const SizedBox(height: 40),
            // Placeholder for any additional UI elements
          ],
        ),
      ),
    );
  }
}
