import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore integration
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication
import 'add_edit_med_screen.dart'; // Import the Add/Edit medication screen
import 'medicationdet_screen.dart';
import 'setting_screen.dart'; // Import Settings screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of screens to navigate between
  static const List<Widget> screens = <Widget>[
    HomeScreenContent(), // Home Screen Content to display medications
    EditScreen(),
    MedicationdetScreen(),// Add/Edit Medication Screen
    SettingsPage(), // Settings Screen
  ];

  void _onItemtap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Today\'s plan',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Add medication'),
          BottomNavigationBarItem(icon: Icon(Icons.medication), label: 'Medication'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemtap,
      ),
    );
  }
}

// Separate widget for the Home tab's content
class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch medications from Firestore for the current user
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('medications')
          .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid) // Query by current user ID
          .snapshots(), // Listen for real-time updates
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Show loading spinner while fetching data
        }

        // Fetch medication documents
        final medications = snapshot.data!.docs;

        if (medications.isEmpty) {
          return const Center(child: Text('No medications added yet.'));
        }

        // Display medications as a list of rectangular cards
        return ListView.builder(
          itemCount: medications.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            var medication = medications[index];
            return MedicationCard(
              medicationName: medication['medication_name'],
              dosageValue: medication['dosage']['value'].toString(),
              dosageUnit: medication['dosage']['unit'],
            );
          },
        );
      },
    );
  }
}

// A custom widget for displaying a medication card
class MedicationCard extends StatelessWidget {
  final String medicationName;
  final String dosageValue;
  final String dosageUnit;

  const MedicationCard({
    Key? key,
    required this.medicationName,
    required this.dosageValue,
    required this.dosageUnit,
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
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text('Dosage: $dosageValue $dosageUnit'),
        trailing: ElevatedButton(
          onPressed: () {
            // Implement button action here, such as viewing medication details
          },
          child: const Text('Details'),
        ),
      ),
    );
  }
}
