import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: const Color(0xFF3C654D),
  colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: const Color(0xFF3C654D),
      tertiary: Colors.white,
      onPrimary: Colors.white,
      secondary: const Color(0xffBEBEBE),
      onSecondary: const Color(0xFF3C654D),
      error: Colors.red,
      onError: Colors.white,
      background: const Color.fromARGB(255, 243, 243, 243),
      onBackground: Colors.black,
      surface: const Color(0xffBEBEBE),
      onSurface: Colors.black,
      onSecondaryContainer: Colors.grey[300]!.withOpacity(.5),
      onTertiary: Colors.grey.shade800),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    foregroundColor: Colors.white,
    backgroundColor: Color(0xFF3C654D),
  ),
  fontFamily: 'ubuntu'
);
