import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'dart:async';
import 'package:volume_control/volume_control.dart';
import 'package:slider_button/slider_button.dart';
import 'package:intl/intl.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  Timer? _timer;
  late DateTime _currentTime;
  late StreamSubscription<QuerySnapshot> _subscription;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _setMaxVolume();
    _startClock();
    _subscribeToAlarms();
  }

  void _setMaxVolume() async {
    await VolumeControl.setVolume(1.0);
  }

  void _startClock() {
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  void _subscribeToAlarms() {
    _subscription = FirebaseFirestore.instance
        .collection('medications')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        var schedule = doc['schedule'] as List<dynamic>;
        for (var entry in schedule) {
          var alarmTime = (entry['timestamp'] as Timestamp).toDate();
          if (alarmTime.isBefore(_currentTime.add(const Duration(minutes: 1))) &&
              alarmTime.isAfter(_currentTime.subtract(const Duration(minutes: 1)))) {
            _playAlarmSound(doc, entry);
          }
        }
      }
    }, onError: (error) {
      print('Error subscribing to medications: $error');
    });
  }

  void _playAlarmSound(DocumentSnapshot doc, dynamic entry) async {
    try {
      FlutterRingtonePlayer.play(
        android: AndroidSounds.alarm,
        ios: IosSounds.alarm,
        looping: true,
        volume: 1.0,
        asAlarm: true,
      );

      // Start a timer to handle missed alarm
      Timer(const Duration(seconds: 30), () {
        // If the alarm is not canceled within 30 seconds
        _triggerEmergencyCall(doc, entry);
      });
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  void _triggerEmergencyCall(DocumentSnapshot doc, dynamic entry) async {
    // Update Firestore document for missed alarm
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshDoc = await transaction.get(doc.reference);
      var updatedSchedule = freshDoc['schedule'] as List<dynamic>;
      var updatedEntry = updatedSchedule.firstWhere((e) => e['timestamp'] == entry['timestamp']);
      updatedEntry['actions']['alarmed'] = true;
      transaction.update(freshDoc.reference, {'schedule': updatedSchedule});
    });

    // Navigate to Missed Alarm Screen
    Navigator.pushReplacementNamed(context, '/MissedAlarmScreen', arguments: doc.id);
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    FlutterRingtonePlayer.stop();
    _subscription.cancel();
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
            SliderButton(
              action: () async {
                FlutterRingtonePlayer.stop();
                // Navigate to Medication Detail Screen
                await Navigator.pushReplacementNamed(context, '/MedicationdetScreen');
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
