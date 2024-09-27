import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'splash_screen.dart'; // Import the splash screen file
import 'firebase_options.dart'; // Add this line if you're using firebase_options.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensures the binding is initialized
  await Firebase.initializeApp();  // Initialize Firebase before running the app
  runApp(const MyApp());
}

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
