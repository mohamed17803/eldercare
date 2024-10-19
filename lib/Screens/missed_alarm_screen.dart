import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:real_volume/real_volume.dart'; //  real_volume
import 'package:slider_button/slider_button.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';
import 'package:torch_light/torch_light.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http; // For Twilio API request
import 'dart:convert'; // For JSON encoding
import 'medication_progress_screen.dart'; // Import the MedicationProgressScreen

class MissedAlarmScreen extends StatefulWidget {
  const MissedAlarmScreen({super.key});

  @override
  _MissedAlarmScreenState createState() => _MissedAlarmScreenState();
}

class _MissedAlarmScreenState extends State<MissedAlarmScreen> {
  Timer? _timer;
  late DateTime _currentTime;
  late AudioPlayer _audioPlayer;
  String medicationName = ''; // Medication name from Firestore
  String dosage = ''; // Dosage from Firestore
  String medicationId = ''; // Store the medication ID for Firestore updates
  String emergencyContactNumber = ''; // Store the emergency contact number

  // Twilio credentials - Place your account SID, auth token, and phone number here
  final String accountSid = 'AIzaSyBiuSVEFRPC5h5VIDRhOxPqFklamGY1r_4'; // Replace with your Twilio Account SID
  final String authToken = '635d0b7d836dc19b801d60024631eee3'; // Replace with your Twilio Auth Token
  final String fromPhoneNumber = '+19093513045'; // Replace with your Twilio phone number

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _audioPlayer = AudioPlayer();
    _setMaxVolume(); // real_volume
    _playAlarmSound();
    _vibratePhone();
    _flashLightBlink();
    _fetchAndDisplayMedicationData(); // Fetch the medication data and display it
    _fetchEmergencyContact(); // Fetch the emergency contact from Firestore
    _startAutoDismissTimer();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  // Set the volume to maximum using real_volume
  void _setMaxVolume() async {
    try {
      await RealVolume.setVolume(1.0, showUI: true); // Set the Volume to th max
    } catch (e) {
      print("Error setting volume: $e");
    }
  }

  // Play the alarm sound
  void _playAlarmSound() async {
    try {
      await _audioPlayer.setSource(AssetSource('assets/medication.mp3'));
      await _audioPlayer.resume();
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  // Vibrate the phone
  void _vibratePhone() async {
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 1000); // Vibrate for 1 second
    } else {
      print("Vibration not supported on this device.");
    }
  }

  // Flash the camera light
  void _flashLightBlink() async {
    try {
      TorchLight.enableTorch();
      await Future.delayed(const Duration(milliseconds: 500)); // Flash for 0.5 sec
      TorchLight.disableTorch();
    } catch (e) {
      print("Error flashing light: $e");
    }
  }

  // Fetch the medication data that was displayed in the AlarmScreen
  Future<void> _fetchAndDisplayMedicationData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Assuming medicationId is passed through navigation arguments
      final String medicationId = ModalRoute.of(context)!.settings.arguments as String;

      DocumentSnapshot medicationDoc = await FirebaseFirestore.instance
          .collection('medications')
          .doc(medicationId)
          .get();

      if (medicationDoc.exists) {
        setState(() {
          medicationName = medicationDoc['medicine'] ?? 'Unknown';
          dosage = '${medicationDoc['dosage']['value']} ${medicationDoc['dosage']['unit']}';
          this.medicationId = medicationId; // Store the medicationId for future updates
        });
      }
    }
  }

  // Fetch emergency contact from Firestore
  Future<void> _fetchEmergencyContact() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('emergency_contacts')
        .where('user_id', isEqualTo: user.uid)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        emergencyContactNumber = snapshot.docs.first['contact_number'];
      });
    }
  }

  // Send SMS via Twilio API
  Future<void> _sendSms() async {
    if (emergencyContactNumber.isNotEmpty) {
      final Uri uri = Uri.parse('https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json');
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('$accountSid:$authToken'))}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'From': fromPhoneNumber,
          'To': emergencyContactNumber,
          'Body': 'Missed medication: $medicationName. Please check on the patient.',
        },
      );

      if (response.statusCode == 201) {
        print('SMS sent successfully!');
      } else {
        print('Failed to send SMS: ${response.body}');
      }
    }
  }

  // Start the auto-dismiss timer
  void _startAutoDismissTimer() {
    const oneMinute = Duration(minutes: 1);
    _timer = Timer(oneMinute, () {
      _sendSms(); // Send the SMS to emergency contact
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MedicationProgressScreen(medicationId: medicationId),
        ),
      );
    });
  }

  // Update time every second
  void _updateTime() {
    setState(() {
      _currentTime = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('yyyy-MM-dd').format(_currentTime);

    return Scaffold(
      backgroundColor: Colors.red, // Set the background color to red for missed alarm
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${_currentTime.hour}:${_currentTime.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 60,
                color: Colors.white,
              ),
            ),
            Text(
              formattedDate,
              style: const TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Missed Medication Alarm',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              medicationName,
              style: const TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Dosage: $dosage',
              style: const TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            SliderButton(
              action: () async {
                _timer?.cancel();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MedicationProgressScreen(medicationId: medicationId),
                  ),
                );
              },
              label: const Text(
                "Swipe to Cancel",
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  color: Colors.red, // Text color to match the red theme
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
              icon: const Text(
                "X",
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 44,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
