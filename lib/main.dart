import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Import your generated Firebase options
import 'Screens/splash_screen.dart'; // Import the splash screen file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensures the binding is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Initialize with default options
  );
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
