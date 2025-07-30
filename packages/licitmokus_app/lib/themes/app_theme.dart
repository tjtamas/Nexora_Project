import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFE6F0FA),
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF90CAF9)),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF64B5F6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A237E),
      ),
    ),
  );
}
