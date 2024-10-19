import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import the LoginPage

class UpdatePasswordScreen extends StatelessWidget {
  UpdatePasswordScreen({super.key}); // Make the controller non-const

  // Add a TextEditingController to get the email input
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6936F5), // Purple background
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous screen
                  },
                ),
                const Text(
                  'Back',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: "Pacifico",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40), // Space between Back and Update Password
            const Center(
              child: Text(
                'Update Password',
                style: TextStyle(
                  color: Colors.white, // Update Password color
                  fontSize: 24,
                  fontFamily: "Pacifico",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20), // Reduce space below Update Password
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0), // Adjust vertical padding
              child: Column(
                children: [
                  // Add controller to capture email input
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email, color: Colors.grey), // Email icon
                      hintText: '...@gmail.com',
                      hintStyle: TextStyle(color: Colors.grey), // Hint text color
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () async {
                      // Add functionality to send the password reset email
                      if (emailController.text.isNotEmpty) {
                        try {
                          await FirebaseAuth.instance.sendPasswordResetEmail(
                            email: emailController.text.trim(),
                          );
                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${e.toString()}')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter an email address')),
                        );
                      }
                    },
                    child: const Text(
                      'Send',
                      style: TextStyle(
                        color: Color(0xFF6936F5), // Button text color
                        fontFamily: "Pacifico",
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Button background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(fontSize: 16),
                      minimumSize: const Size(double.infinity, 0), // Full width button
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
