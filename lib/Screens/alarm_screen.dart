import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:volume_control/volume_control.dart';
import 'package:slider_button/slider_button.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';
import 'package:torch_light/torch_light.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'medication_progress_screen.dart'; // Import the MedicationProgressScreen

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  Timer? _timer;
  late DateTime _currentTime;
  late AudioPlayer _audioPlayer;
  String medicationName = ''; // Medication name from Firestore
  String dosage = ''; // Dosage from Firestore
  String medicationId = ''; // Store the medication ID for Firestore updates

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _audioPlayer = AudioPlayer();
    _setMaxVolume();
    _playAlarmSound();
    _vibratePhone();
    _flashLightBlink();
    _fetchAndDisplayMedicationData(); // Fetch the medication data and display it
    _startAutoDismissTimer();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  // Set the volume to maximum
  void _setMaxVolume() async {
    await VolumeControl.setVolume(1.0);
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

  // Fetch the medication data
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

  // Start the auto-dismiss timer
  void _startAutoDismissTimer() {
    const oneMinute = Duration(minutes: 1);
    _timer = Timer(oneMinute, () {
      Navigator.pushReplacementNamed(context, '/MissedAlarmScreen');
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
      backgroundColor: const Color(0xFF6936F5),
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
              'Medication Alarm',
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
                return true;
              },
              label: const Text(
                "Swipe to Cancel",
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  color: Color(0xFF6936F5),
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
