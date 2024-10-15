import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase for authentication

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Authentication instance
  User? _user; // Current user
  String _emergencyContact = '01069244636'; // Replace with actual emergency contact data
  String _gender = 'Male'; // Replace with actual gender data
  String _dateOfBirth = 'Jun 11, 2002'; // Replace with actual date of birth data

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Mock function to fetch user data
  void _fetchUserData() {
    User? user = _auth.currentUser; // Get current user from Firebase
    if (user != null) {
      setState(() {
        _user = user;
        // You can fetch additional user data here (like gender and date of birth) from Firestore if needed
        // For example:
        // _gender = fetchedGender; // Replace with the actual value fetched from Firestore
        // _dateOfBirth = fetchedDateOfBirth; // Replace with the actual value fetched from Firestore
      });
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
            _buildTextField(label: 'Date of Birth', hint: _dateOfBirth),
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
