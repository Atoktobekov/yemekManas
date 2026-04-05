import 'package:flutter/material.dart';

ThemeData buildLightTheme() {
  return ThemeData(
    fontFamily: 'InstrumentSans',
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFBB8A)),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
      elevation: 3,
      backgroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    scaffoldBackgroundColor: Colors.white,
  );
}

ThemeData buildDarkTheme() {
  return ThemeData(
    fontFamily: 'InstrumentSans',
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFFFBB8A),
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
      elevation: 1,
      centerTitle: true,
    ),
  );
}
