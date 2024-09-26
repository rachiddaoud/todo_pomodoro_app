import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    textTheme: GoogleFonts.openSansTextTheme(),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
      ),
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.blue,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blueGrey,
    textTheme: GoogleFonts.openSansTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blueGrey[900],
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
      ),
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.blueGrey[800],
    ),
  );
}
