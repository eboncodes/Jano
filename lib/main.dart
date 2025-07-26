import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'welcome/welcome_screen.dart';
import 'auth/supabase_service.dart';
import 'dashboard/dashboard_screen.dart';
import 'account/user_info_form_screen.dart';

void main() {
  runApp(const JanoApp());
}

class JanoApp extends StatelessWidget {
  const JanoApp({Key? key}) : super(key: key);

  Future<Widget> _getInitialScreen() async {
    await SupabaseService.initialize();
    final user = SupabaseService().client.auth.currentUser;
    if (user == null) {
      return const WelcomeScreen();
    }
    final complete = await SupabaseService().isProfileComplete(user.id);
    if (complete) {
      return DashboardScreen();
    } else {
      return const UserInfoFormScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jano AI School',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.fredokaTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.yellow,
      ),
      home: FutureBuilder<Widget>(
        future: _getInitialScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            return snapshot.data!;
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
