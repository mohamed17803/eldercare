import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:real_volume/real_volume.dart'; // Import the real_volume package
import 'package:slider_button/slider_button.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';
import 'package:torch_light/torch_light.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'medication_progress_screen.dart'; // Import the MedicationProgressScreen for navigation

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  Timer? _timer; // Timer to handle automatic dismissal of the alarm
  late DateTime _currentTime; // Store the current time for display
  late AudioPlayer _audioPlayer; // Audio player instance to play alarm sound
  String medicationName = ''; // Medication name fetched from Firestore
  String dosage = ''; // Dosage value fetched from Firestore
  String medicationId = ''; // ID of the medication to be fetched and updated in Firestore

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now(); // Initialize the current time
    _audioPlayer = AudioPlayer(); // Initialize the audio player
    _setMaxVolume(); // Set the volume to maximum
    _playAlarmSound(); // Play the alarm sound
    _vibratePhone(); // Trigger phone vibration
    _flashLightBlink(); // Trigger flashlight blink
    _fetchAndDisplayMedicationData(); // Fetch and display medication data from Firestore
    _startAutoDismissTimer(); // Start a timer to automatically dismiss the alarm after 1 minute
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime()); // Update time every second
  }

  // Set the phone's volume to the maximum level using the real_volume package
  void _setMaxVolume() async {
    await RealVolume.setVolume(1.0); // Set volume to maximum (1.0 represents 100%)
  }

  // Play the alarm sound from an asset file (medication.mp3)
  void _playAlarmSound() async {
    try {
      // Set the audio source to the alarm sound file and play it
      await _audioPlayer.setSource(AssetSource('assets/medication.mp3'));
      await _audioPlayer.resume();
    } catch (e) {
      print('Error playing sound: $e'); // Print error message if sound fails to play
    }
  }

  // Vibrate the phone for 1 second (1000 milliseconds)
  void _vibratePhone() async {
    bool? hasVibrator = await Vibration.hasVibrator(); // Check if the device has a vibrator
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 1000); // Vibrate for 1 second
    } else {
      print("Vibration not supported on this device."); // Print message if vibration is not supported
    }
  }

  // Blink the flashlight (flash on for 0.5 seconds, then off)
  void _flashLightBlink() async {
    try {
      TorchLight.enableTorch(); // Turn on the flashlight
      await Future.delayed(const Duration(milliseconds: 500)); // Wait for 0.5 seconds
      TorchLight.disableTorch(); // Turn off the flashlight
    } catch (e) {
      print("Error flashing light: $e"); // Print error message if the flashlight fails
    }
  }

  // Fetch the medication data from Firestore and display it on the screen
  Future<void> _fetchAndDisplayMedicationData() async {
    User? user = FirebaseAuth.instance.currentUser; // Get the current logged-in user

    if (user != null) {
      // Retrieve the medication ID from navigation arguments
      final String medicationId = ModalRoute.of(context)!.settings.arguments as String;

      // Fetch the medication document from the 'medications' collection in Firestore
      DocumentSnapshot medicationDoc = await FirebaseFirestore.instance
          .collection('medications')
          .doc(medicationId)
          .get();

      if (medicationDoc.exists) {
        setState(() {
          // Set the medication name and dosage values
          medicationName = medicationDoc['medicine'] ?? 'Unknown';
          dosage = '${medicationDoc['dosage']['value']} ${medicationDoc['dosage']['unit']}';
          this.medicationId = medicationId; // Store the medication ID for future updates
        });
      }
    }
  }

  // Start a timer that will automatically dismiss the alarm and navigate to the missed alarm screen after 1 minute
  void _startAutoDismissTimer() {
    const oneMinute = Duration(minutes: 1);
    _timer = Timer(oneMinute, () {
      Navigator.pushReplacementNamed(context, '/MissedAlarmScreen'); // Navigate to MissedAlarmScreen after 1 minute
    });
  }

  // Update the current time every second
  void _updateTime() {
    setState(() {
      _currentTime = DateTime.now(); // Update the time
    });
  }

  // Dispose of the resources when the widget is removed from the widget tree
  @override
  void dispose() {
    _timer?.cancel(); // Cancel the auto-dismiss timer
    _audioPlayer.stop(); // Stop the audio player
    _audioPlayer.dispose(); // Dispose of the audio player to free up resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Format the current date in 'yyyy-MM-dd' format
    final String formattedDate = DateFormat('yyyy-MM-dd').format(_currentTime);

    return Scaffold(
      backgroundColor: const Color(0xFF6936F5), // Background color of the screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
          children: <Widget>[
            // Display the current time (hours and minutes)
            Text(
              '${_currentTime.hour}:${_currentTime.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontFamily: 'Pacifico', // Use the Pacifico font
                fontSize: 60, // Large font size for the time
                color: Colors.white, // White text color
              ),
            ),
            // Display the formatted date
            Text(
              formattedDate,
              style: const TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20), // Add vertical space

            // Display "Medication Alarm" text
            const Text(
              'Medication Alarm',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20), // Add vertical space

            // Display the medication name
            Text(
              medicationName,
              style: const TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20), // Add vertical space

            // Display the dosage information
            Text(
              'Dosage: $dosage',
              style: const TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40), // Add vertical space

            // Slider button to cancel the alarm and navigate to the MedicationProgressScreen
            SliderButton(
              action: () async {
                _timer?.cancel(); // Cancel the auto-dismiss timer
                // Navigate to the MedicationProgressScreen and pass the medication ID
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MedicationProgressScreen(medicationId: medicationId),
                  ),
                );
                return true;
              },
              // Label for the slider button
              label: const Text(
                "Swipe to Cancel",
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  color: Color(0xFF6936F5),
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
              // Icon for the slider button
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
