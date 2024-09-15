import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'signup_screen.dart'; // Import the SignupScreen
import 'forget_password_screen.dart'; // Import the ForgetPasswordScreen

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/login_background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text(
                      'Elderly Care',
                      style: TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pacifico',
                        color: Color(0xFF6936F5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50.0),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20.0),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        // Implement your login functionality here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: const Text('Login'),
                    ),
                    const SizedBox(height: 20.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const UpdatePasswordScreen()),
                          );
                        },
                        child: const Text(
                          'Forget Password?',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.facebook,
                            size: 45.0,
                          ),
                          color: Colors.blue,
                          onPressed: () {
                            // Add Facebook login integration here
                          },
                        ),
                        IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.google,
                            size: 45.0,
                          ),
                          color: Colors.red,
                          onPressed: () async {
                            // Implement Google login integration here
                          },
                        ),
                        IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.twitter,
                            size: 45.0,
                          ),
                          color: Colors.cyan,
                          onPressed: () {
                            // Implement Twitter login integration here
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 40.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignupScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                      ),
                      child: const Text(
                        'Sign Up',
                          style: TextStyle(
                          fontSize: 43.0,
                          fontFamily: "Pacifico",
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
