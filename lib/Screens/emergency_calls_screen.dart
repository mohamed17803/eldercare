import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyCallsScreen extends StatefulWidget {
  const EmergencyCallsScreen({super.key});

  @override
  _EmergencyCallsScreenState createState() => _EmergencyCallsScreenState();
}

class _EmergencyCallsScreenState extends State<EmergencyCallsScreen> {
  TwilioFlutter? twilioFlutter;

  @override
  void initState() {
    super.initState();
    twilioFlutter = TwilioFlutter(
      accountSid: 'YOUR_ACCOUNT_SID',
      authToken: 'YOUR_AUTH_TOKEN',
      twilioNumber: 'YOUR_TWILIO_NUMBER',
    );
    _handleEmergencyContact();
  }

  void _handleEmergencyContact() async {
    bool callAnswered = await simulateCall(); // Simulate call response

    if (callAnswered) {
      _updateFirestore('taken', 'phone_called', 'alarmed');
    } else {
      await twilioFlutter?.sendSMS(
        toNumber: 'EMERGENCY_CONTACT_NUMBER', // Replace with actual emergency contact number
        messageBody: 'Emergency Alert: Medication not taken!',
      );
      _updateFirestore('not_taken', 'missed', 'sms_sent');
    }

    Navigator.pushReplacementNamed(context, '/DosagesHistoryScreen');
  }

  Future<bool> simulateCall() async {
    await Future.delayed(Duration(seconds: 3)); // Simulate delay
    return true; // Simulate call answered
  }

  void _updateFirestore(String action1, String action2, String action3) {
    FirebaseFirestore.instance.collection('dosage_history').add({
      'action1': action1,
      'action2': action2,
      'action3': action3,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF6936F5), // Same background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Emergency Call Status',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 30,
                color: Colors.white, // Same font color
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Handling Emergency Contact...',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 20,
                color: Colors.white, // Same font color
              ),
            ),
            SizedBox(height: 40),
            // Placeholder for any additional UI elements
          ],
        ),
      ),
    );
  }
}
