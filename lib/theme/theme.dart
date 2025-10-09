import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: Colors.deepOrange,

  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepOrange,
    primary: Colors.deepOrange,
    secondary: Colors.orangeAccent,
  ),

  scaffoldBackgroundColor: Colors.white,

  appBarTheme: const AppBarTheme(
    elevation: 4,
    backgroundColor: Colors.deepOrange,
    centerTitle: true,
  ),

  textTheme: const TextTheme(
    headlineMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.deepOrange,
    ),

    titleMedium: TextStyle(fontSize: 16),

    bodySmall: TextStyle(fontSize: 14),
  ),

  iconTheme: const IconThemeData(color: Colors.deepOrangeAccent),
);
