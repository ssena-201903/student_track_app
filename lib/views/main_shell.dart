// main_shell.dart
import 'package:flutter/material.dart';
import 'package:student_track/constants/constants.dart';
import 'package:student_track/views/home/home_page.dart';
import 'package:student_track/views/profile/profile_page.dart';
import 'package:student_track/views/subjects/courses_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    CoursesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Constants.primaryWhiteTone,
        currentIndex: _selectedIndex,
        selectedItemColor: Constants.primaryColor,
        unselectedItemColor: Colors.black38,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Ana Sayfa"),
          BottomNavigationBarItem(icon: Icon(Icons.push_pin), label: "Konular"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profilim",
          ),
        ],
      ),
    );
  }
}
