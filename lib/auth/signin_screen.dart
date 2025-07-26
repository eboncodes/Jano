import 'package:flutter/material.dart';
import 'supabase_service.dart';
import '../account/user_info_form_screen.dart';
import '../dashboard/dashboard_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    SupabaseService.initialize();
  }

  Future<void> _handleSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      await SupabaseService().signIn(email, password);
      if (!mounted) return;
      final userId = await SupabaseService().getCurrentUserId();
      if (userId == null) {
        throw Exception('User not found after sign in.');
      }
      final complete = await SupabaseService().isProfileComplete(userId);
      if (complete) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => DashboardScreen()),
          (route) => false,
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const UserInfoFormScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Login Failed'),
          content: Text(
            e.toString().contains('Sign in failed')
                ? 'Login failed: Incorrect email or password.'
                : e.toString().replaceFirst('AuthException: ', ''),
          ),
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
                              'Sign In',
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
                              "Hey! Welcome back🎉",
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
                                      hintText: 'Enter your password',
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
                        const SizedBox(height: 32),
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
                                    onPressed: _loading ? null : _handleSignIn,
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
                                        : const Text('Log in'),
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