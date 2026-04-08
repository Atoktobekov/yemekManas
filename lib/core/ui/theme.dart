import 'package:flutter/material.dart';

ThemeData buildLightTheme() {
  const seed = Color(0xFFFFBB8A);

  final colorScheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.light,
  ).copyWith(
    primary: seed,
    surface: const Color(0xFFFFF8EE),
    surfaceContainer: const Color(0xFFFFF3E7),
    surfaceContainerHigh: const Color(0xFFFDF0E3),
    onSurface: const Color(0xFF1F1A17),
    onSurfaceVariant: const Color(0xFF6E6258),
  );

  return ThemeData(
    brightness: Brightness.light,
    fontFamily: 'InstrumentSans',
    colorScheme: colorScheme,
    scaffoldBackgroundColor: Colors.white,
    dividerColor: const Color(0x1A000000),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Color(0xFF1F1A17),
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Color(0xFFFFBB8A),
      backgroundColor: Colors.white,
      unselectedItemColor: Colors.grey,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
  );
}

ThemeData buildDarkTheme() {
  const seed = Color(0xFFFFBB8A);

  final colorScheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.dark,
  ).copyWith(
    primary: seed,
    surface: const Color(0xFF23262B),
    surfaceContainer: const Color(0xFF2B2F35),
    surfaceContainerHigh: const Color(0xFF31363D),
    onSurface: const Color(0xFFF3EEE8),
    onSurfaceVariant: const Color(0xFFC7BBB0),
  );

  return ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'InstrumentSans',
    colorScheme: colorScheme,
    scaffoldBackgroundColor: const Color(0xFF181A1E),
    dividerColor: const Color(0x26FFFFFF),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      backgroundColor: Color(0xFF141414),
      titleTextStyle: TextStyle(
        color: Color(0xFFF3EEE8),
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: IconThemeData(
        color: Color(0xFFF3EEE8),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Color(0xFFFFBB8A),
      unselectedItemColor: Color(0xFF9A948E),
      backgroundColor: Color(0xFF141414),
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
  );
}