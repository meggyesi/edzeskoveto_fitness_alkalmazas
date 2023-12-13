import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wtracker/src/utils/theme/widget_themes/textFormFieldTheme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      textTheme: TextTheme(
        displayMedium: GoogleFonts.montserrat(color: Colors.black87, fontSize: 24),
        titleSmall: GoogleFonts.montserrat(
          color: Colors.black54,
        ),
      ),
      inputDecorationTheme: TextFormFieldTheme.lightInputDecorationTheme);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: TextTheme(
      displayMedium: GoogleFonts.montserrat(color: Colors.white70, fontSize: 24),
      titleSmall: GoogleFonts.montserrat(
        color: Colors.white54,
        fontSize: 24,
      ),
    ),
    inputDecorationTheme: TextFormFieldTheme.darkInputDecorationTheme,
  );

  static ThemeMode themeMode = ThemeMode.system;
}
