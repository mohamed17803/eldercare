import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DoneSplashScreen extends StatelessWidget {
  const DoneSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.popUntil(context, (route) => route.isFirst); // Go back to home screen
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png'), // Your app logo
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text('Processing...'),
          ],
        ),
      ),
    );
  }
}
