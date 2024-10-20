import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase for authentication
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Authentication instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  User? _user; // Current user
  String _emergencyContact = ''; // Emergency contact of the logged-in user
  String _gender = ''; // Gender of the logged-in user
  String _dateOfBirth = ''; // Date of birth of the logged-in user

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user and Firestore data
  }

  // Fetch user data from Firebase Auth and Firestore
  void _fetchUserData() async {
    User? user = _auth.currentUser; // Get the current logged-in user

    if (user != null) {
      setState(() {
        _user = user; // Set the user in the state
      });

      // Fetch data from Firestore `users` collection for gender, dob, and emergency contact
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final userData = userDoc.data();

      if (userData != null) {
        setState(() {
          _gender = userData['gender'] ?? ''; // Get gender from Firestore
          _dateOfBirth = userData['dob'] ?? ''; // Get date of birth from Firestore
          _emergencyContact = userData['emergency_contact'] ?? ''; // Get emergency contact from Firestore
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6200EE), // Purple background
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontFamily: 'Pacifico')), // Set font to Pacifico
        backgroundColor: const Color(0xFF6200EE),
      ),
      body: SingleChildScrollView( // Wrap the body in a SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: _user == null // Check if user data is available
            ? const Center(child: CircularProgressIndicator()) // Loading indicator
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(label: 'Email', hint: _user!.email ?? '', isEditable: false), // Email field uneditable
            const SizedBox(height: 16),
            _buildTextField(label: 'Emergency Number', hint: _emergencyContact),
            const SizedBox(height: 16),
            _buildTextField(label: 'Gender', hint: _gender, isEditable: false), // Gender field uneditable
            const SizedBox(height: 16),
            _buildTextField(label: 'Date of Birth', hint: _dateOfBirth, isEditable: false), // DOB field uneditable
            const SizedBox(height: 32),
            Center(
              child: Container(
                width: 200, // Set a specific width for the button
                height: 60, // Set a specific height for the button
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 18), // Set font size for button text
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners
                    ),
                  ),
                  onPressed: () {
                    // Handle update action
                  },
                  child: const Text('Update', style: TextStyle(fontFamily: 'Pacifico')), // Set font to Pacifico
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required String hint, bool isEditable = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontFamily: 'Pacifico')), // Set font to Pacifico
        TextField(
          enabled: isEditable, // Set to false for read-only
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          style: const TextStyle(fontFamily: 'Pacifico'), // Set font to Pacifico for text field
        ),
      ],
    );
  }
}
