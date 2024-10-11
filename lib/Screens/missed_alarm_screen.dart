import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'dart:async'; // Import for Timer

class MissedAlarmScreen extends StatefulWidget {
  const MissedAlarmScreen({super.key});

  @override
  _MissedAlarmScreenState createState() => _MissedAlarmScreenState();
}

class _MissedAlarmScreenState extends State<MissedAlarmScreen> {
  TwilioFlutter? twilioFlutter;

  @override
  void initState() {
    super.initState();
    twilioFlutter = TwilioFlutter(
      accountSid: 'YOUR_ACCOUNT_SID',
      authToken: 'YOUR_AUTH_TOKEN',
      twilioNumber: 'YOUR_TWILIO_NUMBER',
    );
    _triggerEmergencyContact();
  }

  void _triggerEmergencyContact() async {
    // Send an SMS as a placeholder for calling
    await twilioFlutter?.sendSMS(
      toNumber: 'EMERGENCY_CONTACT_NUMBER', // Replace with actual emergency contact number
      messageBody: 'Emergency! Please check on the user.',
    );

    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/EmergencyCallsScreen');
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
              'Missed Alarm',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 30,
                color: Colors.white, // Same font color
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Emergency Contact Notified',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 20,
                color: Colors.white, // Same font color
              ),
            ),
            SizedBox(height: 40), //STILL
            // Placeholder for any additional UI elements
          ],
        ),
      ),
    );
  }
}
