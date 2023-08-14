import 'package:flutter/material.dart';

ThemeData myTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  textTheme: const TextTheme(
    bodySmall: TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontFamily: 'Quicksand-Regular',
      fontWeight: FontWeight.w900,
    ),
    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontFamily: 'Quicksand-Regular',
      fontWeight: FontWeight.w900,
    ),
    bodyLarge: TextStyle(
      color: Colors.white,
      fontSize: 45,
      fontFamily: 'Quicksand-Regular',
      fontWeight: FontWeight.w900,
    ),
  ),
);
