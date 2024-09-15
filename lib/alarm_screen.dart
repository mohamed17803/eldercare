import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:volume_control/volume_control.dart';
import 'package:slider_button/slider_button.dart';

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
    await _audioPlayer.play(AssetSource('assets/medication.mp3')); // Ensure you have an alarm sound file in assets
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${_currentTime.hour}:${_currentTime.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontFamily: 'Pacifico', fontSize: 60),
            ),
            Text(
              '${_currentTime.weekday}, ${_currentTime.month} ${_currentTime.day}',
              style: const TextStyle(fontFamily: 'Pacifico', fontSize: 20),
            ),
            const SizedBox(height: 20),
            const Text('Medication Alarm', style: TextStyle(fontFamily: 'Pacifico', fontSize: 30)),
            const SizedBox(height: 20),
            const Text('Lisinopril', style: TextStyle(fontFamily: 'Pacifico', fontSize: 25)),
            const SizedBox(height: 20),
            const Text('Dosage:', style: TextStyle(fontFamily: 'Pacifico', fontSize: 18)),
            const Text('How to take:', style: TextStyle(fontFamily: 'Pacifico', fontSize: 18)),
            const Text('Notes:', style: TextStyle(fontFamily: 'Pacifico', fontSize: 18)),
            const SizedBox(height: 40),
            SliderButton(
              action: () async {
                // Navigate to MedicationdetScreen and handle the Future properly
                await Navigator.pushReplacementNamed(context, '/MedicationdetScreen');
                return true; // Return a valid boolean to match the expected return type
              },
              label: const Text(
                "Swipe to Cancel",
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  color: Color(0xff4a4a4a),
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
