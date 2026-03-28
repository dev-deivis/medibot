import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF1A6B3C);
  static const Color backgroundLight = Color(0xFFF6F8F7);
  static const Color backgroundDark = Color(0xFF131F18);
  static const Color textSlate900 = Color(0xFF0F172A);
  static const Color textSlate500 = Color(0xFF64748B);
  static const Color textSlate400 = Color(0xFF94A3B8);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      surface: Colors.white,
      background: backgroundLight,
    ),
    fontFamily: 'Inter',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: primary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textSlate900,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: textSlate500,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
