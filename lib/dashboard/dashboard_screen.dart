import 'package:flutter/material.dart';
import 'navbar.dart';
import 'my_ai_school_card.dart';
import '../auth/supabase_service.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  late AnimationController _exploreController;
  late AnimationController _schoolCardController;

  String? _nickname;
  String? _userClass;
  String? _role;
  bool _profileLoading = true;

  @override
  void initState() {
    super.initState();
    _exploreController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _schoolCardController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    );
    _exploreController.forward();
    Future.delayed(Duration(milliseconds: 200), () => _schoolCardController.forward());
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final userId = await SupabaseService().getCurrentUserId();
      if (userId != null) {
        final response = await SupabaseService().client.from('profiles').select().eq('id', userId).maybeSingle();
        setState(() {
          _nickname = response != null ? response['nickname'] as String? : null;
          _userClass = response != null ? response['class'] as String? : null;
          _role = response != null ? response['role'] as String? : null;
          _profileLoading = false;
        });
      } else {
        setState(() {
          _profileLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _profileLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _exploreController.dispose();
    _schoolCardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final yellow = Color(0xFFF3C94C);
    final lightPurple = Color(0xFF9B8AFB);
    final dashboardBackground = Color(0xFFFCFCFC);

    return Scaffold(
      backgroundColor: dashboardBackground,
      body: SafeArea(
        child: _profileLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                              ),
                              child: CircleAvatar(
                                radius: 36,
                                backgroundColor: lightPurple,
                                backgroundImage: AssetImage(_getAvatarPath()),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _nickname != null && _nickname!.isNotEmpty
                                          ? 'Hello, $_nickname'
                                          : 'Hello',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
                                    ),
                                    SizedBox(height: 2),
                                    if (_userClass != null && _userClass!.isNotEmpty)
                                      Text('Class $_userClass', style: TextStyle(fontSize: 14, color: Colors.black54)),
                                  ],
                                ),
                              ),
                            ),
                            Icon(Icons.notifications_none, size: 32, color: Colors.black),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      AnimatedBuilder(
                        animation: _schoolCardController,
                        builder: (context, child) {
                          final slide = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero).animate(CurvedAnimation(parent: _schoolCardController, curve: Curves.easeOut));
                          final fade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _schoolCardController, curve: Curves.easeOut));
                          return Opacity(
                            opacity: fade.value,
                            child: Transform.translate(
                              offset: slide.value * 100,
                              child: child,
                            ),
                          );
                        },
                        child: MyAISchoolCard(yellow: yellow, lightPurple: lightPurple),
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text('Explore', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
                      ),
                      SizedBox(height: 20),
                      AnimatedBuilder(
                        animation: _exploreController,
                        builder: (context, child) {
                          final slide = Tween<Offset>(begin: Offset(0, 0.2), end: Offset.zero).animate(CurvedAnimation(parent: _exploreController, curve: Curves.easeOut));
                          final fade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _exploreController, curve: Curves.easeOut));
                          return Opacity(
                            opacity: fade.value,
                            child: Transform.translate(
                              offset: slide.value * 100,
                              child: child,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _ExploreCard(
                                image: 'lib/images/aiteacher.png',
                                label: 'Virtual Teacher',
                                color: lightPurple,
                                showBorder: false,
                              ),
                              _ExploreCard(
                                image: 'lib/images/quiz.png',
                                label: 'Quiz Test',
                                color: lightPurple,
                                showBorder: false,
                              ),
                              _ExploreCard(
                                image: 'lib/images/goal.png',
                                label: 'My Goals',
                                color: lightPurple,
                                showBorder: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 36),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: const DashboardNavbar(),
    );
  }

  String _getAvatarPath() {
    if (_role == 'female') return 'lib/images/female.png';
    if (_role == 'teacher') return 'lib/images/teacher.png';
    return 'lib/images/male.png';
  }
}

class _ExploreCard extends StatefulWidget {
  final String image;
  final String label;
  final Color color;
  final bool showBorder;

  const _ExploreCard({required this.image, required this.label, required this.color, this.showBorder = false});

  @override
  State<_ExploreCard> createState() => _ExploreCardState();
}

class _ExploreCardState extends State<_ExploreCard> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) => setState(() => _scale = 0.96);
  void _onTapUp(TapUpDetails details) => setState(() => _scale = 1.0);
  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: Duration(milliseconds: 100),
        child: Container(
          width: 130,
          height: 170,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(20),
            border: widget.showBorder ? Border.all(color: Color(0xFFE0E0E0), width: 2) : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(widget.image, width: 120, height: 120),
              SizedBox(height: 12),
              Text(widget.label, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
} 