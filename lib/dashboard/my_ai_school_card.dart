import 'package:flutter/material.dart';

class MyAISchoolCard extends StatelessWidget {
  final Color yellow;
  final Color lightPurple;

  const MyAISchoolCard({Key? key, required this.yellow, required this.lightPurple}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 20, 80, 50),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/template1.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.1),
                  BlendMode.darken,
                ),
              ),
              borderRadius: BorderRadius.circular(36),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Keystone Ai Future School', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    children: [
                      TextSpan(text: 'Learn faster '),
                      TextSpan(
                        text: 'smart',
                        style: TextStyle(color: Color(0xFFFFB74D), fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' books,\n'),
                      TextSpan(text: 'Ai '),
                      TextSpan(
                        text: 'teachers',
                        style: TextStyle(color: Color(0xFFFFB74D), fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ', and '),
                      TextSpan(
                        text: 'progress\n',
                        style: TextStyle(color: Color(0xFFFFB74D), fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: 'tracking - all in one app'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 8,
            bottom: 8,
            child: Stack(
              children: [
                // White arc outline (cut off by 25%)
                CustomPaint(
                  size: Size(56, 56),
                  painter: ArcPainter(),
                ),
                // Dark circular button with white arrow
                Positioned(
                  left: 4,
                  top: 4,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
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

class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    // Draw arc with gap on the left side (where arrow is pointing)
    // Start from 45 degrees and sweep 270 degrees (75% of 360)
    canvas.drawArc(rect, 0.785, 4.712, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 