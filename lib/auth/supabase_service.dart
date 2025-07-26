import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  static const String supabaseUrl = 'https://dwocbtibjuerzcilvxal.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR3b2NidGlianVlcnpjaWx2eGFsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI1NzI1ODcsImV4cCI6MjA2ODE0ODU4N30.XKh4x6Ack90xVPAeOkP100l-6x3ZRK6Ft77VodqLnLY';

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (!_initialized) {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );
      _initialized = true;
    }
  }

  final SupabaseClient client = Supabase.instance.client;

  Future<bool> emailExists(String email) async {
    final response = await client.rpc('email_exists', params: {'email': email});
    return response as bool;
  }

  Future<AuthResponse> signUp(String email, String password) async {
    final exists = await emailExists(email);
    if (exists) {
      throw Exception('An account already exists with this email.');
    }
    final response = await client.auth.signUp(email: email, password: password);
    if (response.user == null) {
      throw Exception('Sign up failed');
    }
    return response;
  }

  Future<AuthResponse> signIn(String email, String password) async {
    final response = await client.auth.signInWithPassword(email: email, password: password);
    if (response.user == null) {
      throw Exception('Sign in failed');
    }
    return response;
  }

  Future<String?> getCurrentUserId() async {
    final user = client.auth.currentUser;
    return user?.id;
  }

  Future<bool> isProfileComplete(String userId) async {
    final response = await client.from('profiles').select().eq('id', userId).single();
    if (response == null) return false;
    final name = response['name'] as String?;
    final dob = response['dob'] as String?;
    final userClass = response['class'] as String?;
    final role = response['role'] as String?;
    if (name == null || name.isEmpty || dob == null || dob.isEmpty || userClass == null || userClass.isEmpty || role == null || role.isEmpty) {
      return false;
    }
    if (userClass == '9-10') {
      final subject = response['subject'] as String?;
      if (subject == null || subject.isEmpty) return false;
    }
    return true;
  }
} 