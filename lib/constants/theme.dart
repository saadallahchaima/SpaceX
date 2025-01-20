import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.orange,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.orange,
    foregroundColor: Colors.white,
  ),
  iconTheme: const IconThemeData(
    color: Colors.orange, 
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black87), 
    bodyMedium: TextStyle(color: Colors.black54),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark, 
  primaryColor: Colors.orange,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.orange,
    foregroundColor: Colors.white,
  ),
  iconTheme: const IconThemeData(
    color: Colors.white70, 
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
  ),
);
