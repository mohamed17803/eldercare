import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Import your generated Firebase options
import 'Screens/splash_screen.dart'; // Import the splash screen file
import 'package:permission_handler/permission_handler.dart'; // Import permission handler

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensures the binding is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Initialize with default options
  );
  await requestPermissions(); // Request necessary permissions
  runApp(const MyApp());
}

Future<void> requestPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.sms,
    Permission.phone,
  ].request();

  if (statuses[Permission.camera]!.isDenied) {
    // Handle the case where the user denied the permission
  }
  // Handle other permissions similarly
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
