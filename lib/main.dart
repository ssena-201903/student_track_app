import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_track/views/home/home_page.dart';
import 'package:student_track/views/main_shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: MainShell(),
    );
  }
}
