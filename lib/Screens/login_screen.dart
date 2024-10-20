import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For Firebase Authentication
import 'signup_screen.dart'; // Import the SignupScreen
import 'forget_password_screen.dart'; // Import the ForgetPasswordScreen
import 'home_screen.dart'; // Import your existing HomeScreen

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // Loading state variable

  // Firebase instance for authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Function to handle login process
  Future<void> _login() async {
    if (!_emailController.text.contains('@')) {
      _showErrorDialog("Please enter a valid email address");
      return;
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      // Sign in the user with Firebase Auth Done BY Mohamed Sayed
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Navigate to Home Screen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      _showErrorDialog(
          e.toString()); // Display error message Done by Mohamed Sayed
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  // Function to show error dialogs
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6936F5), // Background color
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Elderly Care',
                    style: TextStyle(
                      fontSize: 38,
                      fontFamily: "Pacifico", // Pacifico font for title
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6936F5), // Updated color
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 32),
                  // Login button
                  _isLoading // Show loading indicator
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _login, // Call the login function
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 50),
                            backgroundColor: const Color(0xFF6936F5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily:
                                  "Pacifico", // Pacifico font for button text
                            ),
                          ),
                        ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UpdatePasswordScreen()), // Navigate to ForgetPasswordScreen
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontFamily:
                            "Pacifico", // Pacifico font for Forgot Password text
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'or sign in with',
                    style: TextStyle(
                      fontFamily:
                          "Pacifico", // Pacifico font for 'or sign in with'
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.google,
                          color: Colors.red, // Set Google icon color to red
                        ),
                        onPressed: () {
                          // Add Google Sign-In functionality here
                        },
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.facebook,
                          color: Colors.blue, // Set Facebook icon color to blue
                        ),
                        onPressed: () {
                          // Add Facebook Sign-In functionality here
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Don't have an account?", // Title text
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Pacifico", // Pacifico font for title
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Sign Up button (styled same as Login button)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SignupScreen()), // Navigate to SignupScreen
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      backgroundColor: const Color(0xFF6936F5),
                      // Same color as Login button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: "Pacifico", // Pacifico font for button text
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
