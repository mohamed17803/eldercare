import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:volume_control/volume_control.dart';
import 'package:slider_button/slider_button.dart';
import 'package:intl/intl.dart'; // For date formatting

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  Timer? _timer;
  late DateTime _currentTime;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _audioPlayer = AudioPlayer();
    _setMaxVolume();
    _playAlarmSound();
    _startAutoDismissTimer();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  void _setMaxVolume() async {
    await VolumeControl.setVolume(1.0); // Set volume to maximum
  }

  void _playAlarmSound() async {
    try {
      // Load the asset and play the sound
      await _audioPlayer.setSource(AssetSource('assets/medication.mp3'));
      await _audioPlayer.resume(); // Ensure the audio is resumed if paused
    } catch (e) {
      print('Error playing sound: $e'); // Handle errors if audio file fails to load
    }
  }

  void _startAutoDismissTimer() {
    const oneMinute = Duration(minutes: 1);
    _timer = Timer(oneMinute, () => Navigator.pushReplacementNamed(context, '/MissedAlarmScreen'));
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.stop();
    _audioPlayer.dispose(); // Properly dispose of the audio player
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Format the date as YYYY-MM-DD
    final String formattedDate = DateFormat('yyyy-MM-dd').format(_currentTime);

    return Scaffold(
      backgroundColor: const Color(0xFF6936F5), // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${_currentTime.hour}:${_currentTime.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 60,
                color: Colors.white, // Font color
              ),
            ),
            Text(
              formattedDate, // Display the formatted date
              style: const TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 20,
                color: Colors.white, // Font color
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Medication Alarm',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 30,
                color: Colors.white, // Font color
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Lisinopril',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 25,
                color: Colors.white, // Font color
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Dosage:',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 18,
                color: Colors.white, // Font color
              ),
            ),
            const Text(
              'How to take:',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 18,
                color: Colors.white, // Font color
              ),
            ),
            const Text(
              'Notes:',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 18,
                color: Colors.white, // Font color
              ),
            ),
            const SizedBox(height: 40),
            SliderButton(
              action: () async {
                _timer?.cancel(); // Cancel the auto-dismiss timer
                await Navigator.pushReplacementNamed(context, '/Med icationdetScreen');
                return true; // Return true to indicate successful slide action
              },
              label: const Text(
                "Swipe to Cancel",
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  color: Color(0xFF6936F5), // Font color
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
              icon: const Text(
                "X",
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  color: Colors.white, // Font color
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
