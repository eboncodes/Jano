import 'package:flutter/material.dart';

class DashboardNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const DashboardNavbar({Key? key, this.currentIndex = 0, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lightPurple = Color(0xFF9B8AFB);
    final navSelected = lightPurple;
    final navUnselected = Colors.black54;
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFF0F0F0), // slightly darker white
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 14,
      unselectedFontSize: 14,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, color: navSelected),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, color: navUnselected),
      selectedItemColor: navSelected,
      unselectedItemColor: navUnselected,
      showUnselectedLabels: true,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'AI School'),
        BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'AI Teacher'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
} 