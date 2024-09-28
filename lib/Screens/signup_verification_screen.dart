import 'package:flutter/material.dart';

import 'login_screen.dart';

class SignUpVerificationScreen extends StatelessWidget {
  const SignUpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // Logo
            Positioned(
              top: 50, // Adjust the position of the logo
              child: HeartLogo(),
            ),

            // Column with texts and button
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 200), // Add space to position the texts below the logo

                // Welcome Text
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0), // Adjust padding
                  child: Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 32, // Set font size to make it big
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6936F5), // Set text color
                      fontFamily: 'Pacifico', // Set font to Pacifico
                    ),
                  ),
                ),

                // Sign Up Completed Text
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 24.0), // Adjust padding to lower the text
                  child: Text(
                    'Sign Up Completed!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6936F5), // Set text color
                      fontFamily: 'Pacifico', // Set font to Pacifico
                    ),
                  ),
                ),

                // Go to Login Page Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()), // Navigate to LoginPage
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6936F5), // Set button color
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), // Increase button size
                  ),
                  child: Text(
                    'Go to Login Page',
                    style: TextStyle(
                      color: Colors.white, // Set text color to white
                      fontFamily: 'Pacifico', // Set font to Pacifico
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HeartLogo extends StatelessWidget {
  const HeartLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset('images/ec_logo.png', width: 520, height: 520), // Increase logo size
    );
  }
}
