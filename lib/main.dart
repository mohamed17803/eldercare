import 'package:flutter/material.dart';
import 'splash_screen.dart'; // Import the splash screen file
//Last Check
// CHeck
void main() => runApp( const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Hide the debug banner
      home: SplashScreen(), // Set the SplashScreen as the home screen
    );
  }
}
