import 'package:flutter/material.dart';
import '../auth/signup_screen.dart';
import '../auth/signin_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final yellow = Color(0xFFF3C94C);
    final lightPurple = Color(0xFF9B8AFB);
    return Scaffold(
      backgroundColor: lightPurple,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'lib/images/Background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Main content
          SingleChildScrollView(
            child: Column(
              children: [
                // Logo
                Image.asset(
                  'lib/images/Logo.png',
                  width: 260,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 40),
                // Card-like area for text and buttons
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 0),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(48),
                      topRight: Radius.circular(48),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 24,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        "Let's get started",
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Welcome to Jano AI School, Join us today!🎉',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      // Sign Up button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const SignupScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: yellow,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              elevation: 2,
                              textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                            ),
                            child: const Text('Sign Up'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Sign In button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const SigninScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: yellow,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              elevation: 2,
                              textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                            ),
                            child: const Text('Sign In'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 24.0),
                        child: Text(
                          'Powered by TEJ Intelligence, Bangladesh',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 