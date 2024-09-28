import 'package:flutter/material.dart';
import 'dart:async';
import 'login_screen.dart'; // Import the login screen file

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<int> _textAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController to run only in the forward direction
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Define the scale animation (Logo keeps scaling up and down)
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Define opacity animation for the logo
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Define text animation for "Elder Care"
    _textAnimation = StepTween(begin: 0, end: "Elder Care".length).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Start the text animation
    _controller.forward();

    // After 5 seconds, navigate to the LoginPage
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo animation (scaling and opacity)
            ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: Image.asset('images/ec_logo.png'), // Replace with your asset image path
              ),
            ),
            const SizedBox(height: 80),
            // Text animation (title)
            AnimatedBuilder(
              animation: _textAnimation,
              builder: (context, child) {
                String animatedText = "Elder Care".substring(0, _textAnimation.value);
                return Text(
                  animatedText,
                  style: const TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 40,
                    color: Color(0xFF6936F5), // Custom color
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
