import 'package:eldercare/Screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'add_edit_med_screen.dart';
import 'login_screen.dart';
import 'medicationdet_screen.dart';
import 'setting_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> screens = <Widget>[
    HomeScreenContent(),
    HistoryScreen(),
    EditScreen(),
    SettingsPage(),
  ];

  void _onItemtap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6936F5),
      appBar: AppBar(
        title: const Text(
          'Today\'s Plan',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Pacifico',
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6936F5),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF6936F5),
              ),
              child: Text(
                'Elderly Care',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'Pacifico',
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(
                'Profile',
                style: TextStyle(fontFamily: 'Pacifico'),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text(
                'Notifications',
                style: TextStyle(fontFamily: 'Pacifico'),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text(
                'Help',
                style: TextStyle(fontFamily: 'Pacifico'),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                'Logout',
                style: TextStyle(fontFamily: 'Pacifico'),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Add medication'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemtap,
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(
        child: Text(
          'User not logged in',
          style: TextStyle(fontSize: 18, fontFamily: 'Pacifico'),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('medications')
          .where('user_id', isEqualTo: currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong', style: TextStyle(fontFamily: 'Pacifico')));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final medications = snapshot.data!.docs;

        if (medications.isEmpty) {
          return const Center(child: Text('No medications added yet.', style: TextStyle(fontFamily: 'Pacifico')));
        }

        final today = DateTime.now();
        final String todayDate = DateFormat('yyyy-MM-dd').format(today);

        return ListView.builder(
          itemCount: medications.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            var medication = medications[index];
            var medicationData = medication.data() as Map<String, dynamic>;

            // Extract alarm trigger times for today
            List<dynamic> schedule = medicationData['schedule'] ?? [];
            String alarmTime = '';
            for (var entry in schedule) {
              if (entry['alarm_trigger_time'] != null &&
                  entry['alarm_trigger_time'] is Timestamp) {
                DateTime alarmTriggerTime = (entry['alarm_trigger_time'] as Timestamp).toDate();
                if (DateFormat('yyyy-MM-dd').format(alarmTriggerTime) == todayDate) {
                  alarmTime = DateFormat.jm().format(alarmTriggerTime); // Format the time as needed
                  break; // Use the first matching alarm time
                }
              }
            }

            return MedicationCard(
              medicationId: medication.id,
              medicationName: medicationData['medicine'] ?? 'Unknown Medication',
              dosageValue: (medicationData['dosage']?['value']?.toString() ?? '0'),
              dosageUnit: (medicationData['dosage']?['unit'] ?? 'N/A'),
              alarmTime: alarmTime, // Pass the alarm time to MedicationCard
            );
          },
        );
      },
    );
  }
}

class MedicationCard extends StatelessWidget {
  final String medicationId;
  final String medicationName;
  final String dosageValue;
  final String dosageUnit;
  final String alarmTime; // Add alarm time

  const MedicationCard({
    Key? key,
    required this.medicationId,
    required this.medicationName,
    required this.dosageValue,
    required this.dosageUnit,
    required this.alarmTime, // Accept alarm time
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          medicationName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Pacifico'),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dosage: $dosageValue $dosageUnit', style: const TextStyle(fontFamily: 'Pacifico')),
            Text('Alarm Time: $alarmTime', style: const TextStyle(fontFamily: 'Pacifico')), // Display the alarm time
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MedicationDetailsScreen(medicationId: medicationId),
              ),
            );
          },
          child: const Text(
            'Details',
            style: TextStyle(fontFamily: 'Pacifico'),
          ),
        ),
      ),
    );
  }
}
