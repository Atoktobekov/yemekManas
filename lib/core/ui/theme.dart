import 'package:flutter/material.dart';

ThemeData buildLightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    fontFamily: 'InstrumentSans',
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFFFBB8A),
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
      elevation: 3,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Color(0xFFFFBB8A),
      backgroundColor: Colors.white,
      unselectedItemColor: Colors.grey,
    ),
  );
}

ThemeData buildDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'InstrumentSans',
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFFFBB8A),
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
      elevation: 3,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Color(0xFFFFBB8A),
      unselectedItemColor: Colors.grey,
    ),
  );
}
