import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telephony/telephony.dart';
import 'dart:async';

class MissedAlarmScreen extends StatefulWidget {
  const MissedAlarmScreen({super.key});

  @override
  _MissedAlarmScreenState createState() => _MissedAlarmScreenState();
}

class _MissedAlarmScreenState extends State<MissedAlarmScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
  final Telephony telephony = Telephony.instance; // Telephony instance

  @override
  void initState() {
    super.initState();
    _triggerEmergencyContact();
  }

  Future<void> _triggerEmergencyContact() async {
    String emergencyContactNumber = await _getEmergencyContactNumber(); // Fetch the emergency contact number

    try {
      // Send an SMS to notify the emergency contact
      await telephony.sendSms(
        to: emergencyContactNumber,
        message: 'Emergency! Please check on the user.',
      );

      // Optionally, show a success message
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Emergency contact notified via SMS!'),
      ));

      // Automatically make the emergency call
      await _makeEmergencyCall(emergencyContactNumber);

    } catch (e) {
      // Handle errors appropriately
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to notify emergency contact: $e'),
      ));
    }

    // Navigate to the Emergency Calls Screen after a delay
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/EmergencyCallsScreen');
    });
  }

  Future<void> _makeEmergencyCall(String emergencyContactNumber) async {
    // Implement your emergency call logic here
    print('Calling $emergencyContactNumber...');
  }

  Future<String> _getEmergencyContactNumber() async {
    User? user = FirebaseAuth.instance.currentUser; // Get the currently logged-in user
    if (user == null) return '01069246636'; // Default number if user is not logged in

    // Fetch emergency contact from Firestore
    QuerySnapshot snapshot = await _firestore.collection('emergency_contacts')
        .where('user_id', isEqualTo: user.uid)
        .limit(1) // Limit to one contact
        .get();

    if (snapshot.docs.isNotEmpty) {
      // If a contact is found, return the contact number
      return snapshot.docs.first['contact_number'];
    } else {
      // Return a default/fallback number if no contact is found
      return '01069246636'; // Replace with a default number if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF6936F5), // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Missed Alarm',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 30,
                color: Colors.white, // Font color
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Emergency Contact Notified',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 20,
                color: Colors.white, // Font color
              ),
            ),
            SizedBox(height: 40), // Placeholder for any additional UI elements
          ],
        ),
      ),
    );
  }
}
// ok