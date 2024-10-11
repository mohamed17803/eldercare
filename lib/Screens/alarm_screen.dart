import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:volume_control/volume_control.dart';
import 'package:slider_button/slider_button.dart';
import 'package:intl/intl.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  Timer? _timer;
  late DateTime _currentTime;
  late AudioPlayer _audioPlayer;
  late StreamSubscription<QuerySnapshot> _subscription;
  TwilioFlutter? twilioFlutter;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _audioPlayer = AudioPlayer();
    twilioFlutter = TwilioFlutter(
      accountSid: 'YOUR_ACCOUNT_SID',
      authToken: 'YOUR_AUTH_TOKEN',
      twilioNumber: 'YOUR_TWILIO_NUMBER',
    );
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
      print('Medications snapshot received with ${snapshot.docs.length} documents');
      for (var doc in snapshot.docs) {
        var schedule = doc['schedule'] as List<dynamic>;
        for (var entry in schedule) {
          var alarmTime = (entry['timestamp'] as Timestamp).toDate();
          print('Checking alarm time: $alarmTime');
          if (alarmTime.isBefore(_currentTime.add(const Duration(minutes: 1))) &&
              alarmTime.isAfter(_currentTime.subtract(const Duration(minutes: 1)))) {
            print('Playing alarm for document: ${doc.id}');
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
      await _audioPlayer.setSource(AssetSource('assets/medication.mp3'));
      await _audioPlayer.resume();
      Timer(Duration(seconds: 30), () {
        _audioPlayer.stop();
        _triggerEmergencyCall(doc, entry);
      });
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  void _triggerEmergencyCall(DocumentSnapshot doc, dynamic entry) async {
    // Update the Firestore document to reflect the missed alarm
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshDoc = await transaction.get(doc.reference);
      var updatedSchedule = freshDoc['schedule'] as List<dynamic>;
      var updatedEntry = updatedSchedule.firstWhere((e) => e['timestamp'] == entry['timestamp']);
      updatedEntry['actions']['alarmed'] = true;
      updatedEntry['actions']['phone_called'] = true; // Or false, depending on logic
      updatedEntry['actions']['sms_sent'] = true; // Or false, depending on logic
      transaction.update(freshDoc.reference, {'schedule': updatedSchedule});
    });
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
    _audioPlayer.stop();
    _audioPlayer.dispose();
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
                _timer?.cancel();
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
// Still Trying