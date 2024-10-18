import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

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
        setState(() {
          isCalling = true; // Set to true when contact is fetched
        });
        // Make the call immediately
        await _makeCall(emergencyContactNumber);
      } else {
        print('No emergency contact found for this user.');
      }
    } catch (e) {
      print("Error fetching emergency contact: $e");
    }
  }

  // Function to handle phone call and navigate to home screen after the call ends
  Future<void> _makeCall(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
    // After the call ends, navigate to the home screen
    _navigateToHome();
  }

  // Navigate to the home screen
  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/home'); // Adjust the route name to your home screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6936F5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Emergency Call Status',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            if (isCalling) ...[
              Text(
                'Calling $emergencyContactNumber...',
                style: const TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ] else ...[
              const Text(
                'No emergency contact found.',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
