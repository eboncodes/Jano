import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth/supabase_service.dart';
import '../dashboard/dashboard_screen.dart';

class UserInfoFormScreen extends StatefulWidget {
  const UserInfoFormScreen({Key? key}) : super(key: key);

  @override
  State<UserInfoFormScreen> createState() => _UserInfoFormScreenState();
}

class _UserInfoFormScreenState extends State<UserInfoFormScreen> {
  int? _selectedRole; // 0: Male, 1: Female, 2: Teacher
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  DateTime? _selectedDob;
  final TextEditingController _classController = TextEditingController();
  String? _selectedSubject;
  bool _loading = false;

  final Color yellow = const Color(0xFFF3C94C);
  final Color lightPurple = const Color(0xFF9B8AFB);

  final List<String> _classOptions = [
    '6', '7', '8', '9-10'
  ];
  final List<String> _subjectOptions = [
    'Science', 'Arts', 'Commerce'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellow,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Logo
              Image.asset(
                'lib/images/Logo.png',
                width: 220,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: lightPurple,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Select your role',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _roleOption(0, 'Male Student', 'lib/images/male.png'),
                          _roleOption(1, 'Female Student', 'lib/images/female.png'),
                          _roleOption(2, 'Teacher', 'lib/images/teacher.png'),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Tell us about yourself',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _label('Full Name'),
                      _inputField(_nameController, 'Enter your full name'),
                      const SizedBox(height: 12),
                      _label('Nickname'),
                      _inputField(_nicknameController, 'Enter your nickname'),
                      const SizedBox(height: 16),
                      _label('Date of Birth'),
                      _dobField(),
                      const SizedBox(height: 16),
                      _label('Class'),
                      _classDropdown(),
                      if (_classController.text == '9-10') ...[
                        const SizedBox(height: 16),
                        _label('Subject'),
                        _subjectDropdown(),
                      ],
                      const SizedBox(height: 32),
                      Center(
                        child: SizedBox(
                          width: 220,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _onContinue,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: yellow,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              elevation: 2,
                              textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
                            ),
                            child: _loading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                                  )
                                : const Text('Continue'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleOption(int value, String label, String imagePath) {
    final bool selected = _selectedRole == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = value),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: yellow,
              borderRadius: BorderRadius.circular(32), // larger radius
              border: selected ? Border.all(color: Colors.white, width: 4) : null,
              boxShadow: [
                if (selected)
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
              ],
            ),
            padding: const EdgeInsets.all(20), // larger padding
            child: Image.asset(
              imagePath,
              width: 100, // larger image
              height: 100,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 12), // more space
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              fontSize: 18, // larger font
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 4),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      );

  Widget _inputField(TextEditingController controller, String hint, {TextInputType keyboardType = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(
        color: yellow,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 18, color: Colors.brown),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          hintText: hint,
          hintStyle: TextStyle(fontSize: 18, color: Colors.brown.withOpacity(0.6)),
          border: InputBorder.none,
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _dobField() {
    return GestureDetector(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDob ?? DateTime(now.year - 10),
          firstDate: DateTime(1980),
          lastDate: now,
        );
        if (picked != null) {
          setState(() {
            _selectedDob = picked;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: yellow,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.white, width: 2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        alignment: Alignment.centerLeft,
        height: 56,
        child: Text(
          _selectedDob != null
              ? '${_selectedDob!.year}-${_selectedDob!.month.toString().padLeft(2, '0')}-${_selectedDob!.day.toString().padLeft(2, '0')}'
              : 'Select your date of birth',
          style: TextStyle(
            fontSize: 18,
            color: _selectedDob != null ? Colors.brown : Colors.brown.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  Widget _classDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: yellow,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white, width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: DropdownButtonFormField<String>(
        value: _classController.text.isNotEmpty ? _classController.text : null,
        items: _classOptions
            .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(color: Colors.brown, fontSize: 18))))
            .toList(),
        onChanged: (val) {
          setState(() {
            _classController.text = val ?? '';
            if (_classController.text != '9-10') {
              _selectedSubject = null;
            }
          });
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Class',
          hintStyle: TextStyle(color: Colors.brown, fontSize: 18),
        ),
        dropdownColor: yellow,
      ),
    );
  }

  Widget _subjectDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: yellow,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white, width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: DropdownButtonFormField<String>(
        value: _selectedSubject,
        items: _subjectOptions
            .map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(color: Colors.brown, fontSize: 18))))
            .toList(),
        onChanged: (val) => setState(() => _selectedSubject = val),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Subject',
          hintStyle: TextStyle(color: Colors.brown, fontSize: 18),
        ),
        dropdownColor: yellow,
      ),
    );
  }

  Future<void> _onContinue() async {
    if (_selectedRole == null ||
        _nameController.text.trim().isEmpty ||
        _nicknameController.text.trim().isEmpty ||
        _selectedDob == null ||
        _classController.text.trim().isEmpty ||
        (_classController.text == '9-10' && (_selectedSubject == null || _selectedSubject!.isEmpty))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select a role.')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      final userId = await SupabaseService().getCurrentUserId();
      if (userId == null) throw Exception('User not found. Please sign in again.');
      final role = _selectedRole == 0
          ? 'male'
          : _selectedRole == 1
              ? 'female'
              : 'teacher';
      final profileData = {
        'id': userId,
        'name': _nameController.text.trim(),
        'dob': _selectedDob != null ? '${_selectedDob!.year}-${_selectedDob!.month.toString().padLeft(2, '0')}-${_selectedDob!.day.toString().padLeft(2, '0')}' : '',
        'class': _classController.text.trim(),
        'role': role,
      };
      if (_nicknameController.text.trim().isNotEmpty) {
        profileData['nickname'] = _nicknameController.text.trim();
      }
      if (_classController.text == '9-10' && _selectedSubject != null) {
        profileData['subject'] = _selectedSubject!;
      }
      final response = await Supabase.instance.client.from('profiles').upsert(profileData);
      // No error check needed; rely on try/catch for error handling
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => DashboardScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }
} 