import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore integration
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication

// Custom ListTile widget
class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const CustomListTile({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: 4),  // Make the tile taller
      leading: Icon(icon, color: const Color(0xFF6936F5)), // Set icon color
      title: Text(title, style: const TextStyle(color: Color(0xFF6936F5))), // Set text color
      trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF6936F5)), // Set trailing icon color
      onTap: onTap,
    );
  }
}

// SettingsPage using CustomListTile
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userName = 'User';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name'] ?? 'User';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Color(0xFF6936F5))),
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Profile section
          ListTile(
            visualDensity: const VisualDensity(vertical: 4),  // Make the tile taller
            leading: const CircleAvatar(
              backgroundImage: AssetImage('images/elderly.png'), // Add your own profile image
            ),
            title: Text(userName, style: const TextStyle(color: Color(0xFF6936F5))), // Display user's name
          ),

          // Settings options
          Expanded(
            child: ListView(
              children: [
                CustomListTile(
                  icon: Icons.language,
                  title: 'Language',
                  onTap: () {
                    // Navigate to Language settings
                  },
                ),
                CustomListTile(
                  icon: Icons.notifications,
                  title: 'Notification',
                  onTap: () {
                    // Navigate to Notification settings
                  },
                ),
                CustomListTile(
                  icon: Icons.account_box,
                  title: 'Manage Your account',
                  onTap: () {
                    // Navigate to Manage Your account
                  },
                ),
                CustomListTile(
                  icon: Icons.contact_emergency,
                  title: 'Emergency',
                  onTap: () {
                    // Navigate to Emergency settings
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
