import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_track/constants/constants.dart';
import 'package:student_track/views/home/home_page.dart';
import 'package:student_track/views/login/login_page.dart';
import 'package:student_track/views/main_shell.dart';
import 'package:student_track/views/questions/questions_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // scaffold background color
        scaffoldBackgroundColor: Colors.white,
        // app bar theme
        appBarTheme: AppBarTheme(
          backgroundColor: Constants.primaryColor,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
          centerTitle: false,
        ),
        // floating action button theme
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Constants.primaryColor,
          foregroundColor: Colors.white,
        ),
        // elevated button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Constants.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(8),
            ),
          ),
        ),
        // dialog theme
        dialogTheme: DialogThemeData(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        // text button theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Constants.primaryColor),
        ),
        // text theme
        textTheme: GoogleFonts.poppinsTextTheme(),
        // card theme
        cardTheme: CardThemeData(
          color: Constants.primaryWhiteTone,
          elevation: 1.5,
        ),
        // checkbox theme
        checkboxTheme: CheckboxThemeData(
          checkColor: WidgetStatePropertyAll(Constants.primaryWhiteTone),
          fillColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.selected)) {
              return Constants.primaryColor;
            }
            return null;
          }),
        ),
        // input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Constants.primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Constants.primaryColor),
          ),
          hintStyle: TextStyle(color: Constants.primaryColor),
          labelStyle: TextStyle(color: Constants.primaryColor),
        ),
        // snackbar theme
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.black54,
          contentTextStyle: TextStyle(
            color: Constants.primaryWhiteTone,
            fontSize: 16,
          ),
        ),
        // tabbar theme
        tabBarTheme: TabBarThemeData(
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Constants.primaryColor),
          unselectedLabelColor:
              Constants.primaryWhiteTone,
          indicator: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
          ),
          indicatorSize: TabBarIndicatorSize.tab, 
        ),
      ),

      home: MainShell(),
    );
  }
}
