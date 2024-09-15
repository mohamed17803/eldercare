import 'package:flutter/material.dart';
import 'splash_screen.dart'; // Import the splash screen file
import 'edit_screen.dart';
import 'setting_screen.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Hide the debug banner
      home: SplashScreen(), // Set the SplashScreen as the home screen
    );
  }
}
