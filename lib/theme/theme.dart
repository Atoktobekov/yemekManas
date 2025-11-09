import 'package:flutter/material.dart';

const Color softOrange = Color(0xFFFFA552);
const Color cremeColor = Color(0xFFFFE6C8);
const Color secondCremeColor = Color(0xFFFAEEDD);
const Color secondAccent = Color(0xFFD1783A);

final ThemeData appTheme = ThemeData(
  primaryColor: softOrange,

  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: softOrange,
    onPrimary: Colors.white,
    secondary: secondAccent,
    onSecondary: Colors.white,
    surface: cremeColor,
    onSurface: Colors.black87,
    error: Colors.redAccent,
    onError: Colors.white,
  ),

  scaffoldBackgroundColor: cremeColor,

  appBarTheme: const AppBarTheme(
    elevation: 3,
    backgroundColor: softOrange,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),

  textTheme: const TextTheme(
    headlineMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Color(0xFFDCA56C),
    ),
    titleMedium: TextStyle(fontSize: 16, color: Colors.black87),
    bodySmall: TextStyle(fontSize: 14, color: Colors.black87),
  ),

  iconTheme: const IconThemeData(color: secondAccent),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: softOrange,
    foregroundColor: Colors.white,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: softOrange,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
  ),
);
