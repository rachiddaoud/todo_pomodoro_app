// lib/themes/text_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle get headline1 => GoogleFonts.lato(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      );

  static TextStyle get headline2 => GoogleFonts.lato(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      );

  static TextStyle get bodyText => GoogleFonts.lato(
        fontSize: 16,
        color: Colors.black87,
      );

  static TextStyle get buttonText => GoogleFonts.lato(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );
}
