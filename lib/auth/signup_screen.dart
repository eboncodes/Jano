import 'package:flutter/material.dart';
import 'supabase_service.dart';
import '../welcome/welcome_screen.dart';
import '../account/user_info_form_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    SupabaseService.initialize();
  }

  Future<void> _handleSignUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final rePassword = _rePasswordController.text;
    if (email.isEmpty || password.isEmpty || rePassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }
    if (password != rePassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      await SupabaseService().signUp(email, password);
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Account created! Please check your email to verify.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                  (route) => false,
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      String errorMsg = e.toString().replaceFirst('AuthException: ', '');
      final lower = errorMsg.toLowerCase();
      if ((lower.contains('already') && lower.contains('exist')) ||
          (lower.contains('already') && lower.contains('register'))) {
        errorMsg = 'An account already exists with this email.';
      }
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Sign Up Failed'),
          content: Text(errorMsg),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

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
                const SizedBox(height: 0),
                // Logo
                Image.asset(
                  'lib/images/Logo.png',
                  width: 260,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                // Card-like area for form
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 0),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(48),
                      topRight: Radius.circular(48),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.0),
                          child: Center(
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
                          child: Center(
                            child: Text(
                              "Hello, let's join with us!🎉",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Email field
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: yellow,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Icon(Icons.alternate_email_outlined, color: Colors.brown, size: 24),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter your email',
                                      hintStyle: TextStyle(fontSize: 18, color: Colors.brown.withOpacity(0.6)),
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(fontSize: 18, color: Colors.brown),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Password field with toggle
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: yellow,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Icon(Icons.lock_outline_rounded, color: Colors.brown, size: 24),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    decoration: InputDecoration(
                                      hintText: 'Enter a strong password',
                                      hintStyle: TextStyle(fontSize: 18, color: Colors.brown.withOpacity(0.6)),
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(fontSize: 18, color: Colors.brown),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                    color: Colors.brown,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Re-enter password field
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: yellow,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Icon(Icons.lock_outline_rounded, color: Colors.brown, size: 24),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _rePasswordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: 'Re-enter your password',
                                      hintStyle: TextStyle(fontSize: 18, color: Colors.brown.withOpacity(0.6)),
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(fontSize: 18, color: Colors.brown),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Terms text
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Center(
                            child: Text.rich(
                              TextSpan(
                                text: 'By signing in you agree the terms of Jano AI School, ',
                                style: const TextStyle(fontSize: 16, color: Colors.black87),
                                children: [
                                  TextSpan(
                                    text: 'terms of service',
                                    style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Buttons
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: yellow,
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      elevation: 2,
                                      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                                    ),
                                    child: const Text('Back'),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: _loading ? null : _handleSignUp,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: yellow,
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      elevation: 2,
                                      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                                    ),
                                    child: _loading
                                        ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                                          )
                                        : const Text('Create'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
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