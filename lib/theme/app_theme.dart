import 'package:flutter/material.dart';

class AppTheme {
  static const neonBlue = Color(0xFF00F0FF);
  static const neonPink = Color(0xFFFF00E0);
  static const neonGreen = Color(0xFF39FF14);
  static const neonPurple = Color(0xFF9D00FF);
  static const neonYellow = Color(0xFFFFFF00);

  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: neonBlue,
          onPrimary: Colors.white,
          secondary: neonPink,
          onSecondary: Colors.white,
          error: Colors.redAccent,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: neonBlue,
        ),
        scaffoldBackgroundColor: const Color(0xFF181A20),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: neonBlue),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            
            fontWeight: FontWeight.bold,
            color: neonBlue,
            letterSpacing: 2.0,
            shadows: [
              Shadow(blurRadius: 18, color: neonBlue, offset: Offset(0, 0)),
            ],
          ),
          titleMedium: TextStyle(
            
            color: neonPink,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            shadows: [
              Shadow(blurRadius: 12, color: neonPink, offset: Offset(0, 0)),
            ],
          ),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: neonPink,
          onPrimary: Colors.white,
          secondary: neonBlue,
          onSecondary: Colors.white,
          error: Colors.redAccent,
          onError: Colors.white,
          surface: const Color(0xFF23263A),
          onSurface: neonPink,
        ),
        scaffoldBackgroundColor: const Color(0xFF181A20),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: neonPink),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            
            fontWeight: FontWeight.bold,
            color: neonPink,
            letterSpacing: 2.0,
            shadows: [
              Shadow(blurRadius: 18, color: neonPink, offset: Offset(0, 0)),
            ],
          ),
          titleMedium: TextStyle(
            
            color: neonBlue,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            shadows: [
              Shadow(blurRadius: 12, color: neonBlue, offset: Offset(0, 0)),
            ],
          ),
        ),
      );
}