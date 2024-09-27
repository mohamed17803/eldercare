import 'package:flutter/material.dart';

class SignUpVerificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Logo
            HeartLogo(),

            // Sign Up Completed Text
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Sign up completed!',
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
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Go to Login Page'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6936F5), // Set button color
              ),
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
      child: Image.asset('images/ec_logo.png', width: 100, height: 100), // Use your logo image
      margin: EdgeInsets.only(bottom: 30),
    );
  }
}
