import 'package:flutter/material.dart';

ThemeData myTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xff0B2447),
  ),
  textTheme: const TextTheme(
    bodySmall: TextStyle(
      color: Colors.white70,
      fontSize: 14,
      fontFamily: 'Quicksand-Regular',
      fontWeight: FontWeight.w900,
    ),
    bodyMedium: TextStyle(
      color: Colors.white70,
      fontSize: 15,
      fontFamily: 'Quicksand-Regular',
      fontWeight: FontWeight.w900,
    ),
    bodyLarge: TextStyle(
      color: Colors.white70,
      fontSize: 25,
      fontFamily: 'Quicksand-Regular',
      fontWeight: FontWeight.w900,
    ),
    labelMedium: TextStyle(
      color: Colors.blue,
      fontFamily: 'Quicksand-Regular',
      fontSize: 13,
      fontWeight: FontWeight.w700,
    ),
    labelSmall: TextStyle(
      color: Colors.white70,
      fontFamily: 'Quicksand-Regular',
      fontSize: 12,
      fontWeight: FontWeight.w700,
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: Colors.white70,
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: Color(0xff0B2447),
    titleTextStyle: TextStyle(
      color: Colors.white70,
      fontFamily: 'Quicksand-Regular',
      fontSize: 25,
      fontWeight: FontWeight.w700
    ),
    contentTextStyle: TextStyle(
      color: Colors.white70,
      fontFamily: 'Quicksand-Regular',
      fontSize: 15,
    ),
  ),
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(Colors.white54),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    foregroundColor: Colors.white70,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Colors.white70,
  ),
);
