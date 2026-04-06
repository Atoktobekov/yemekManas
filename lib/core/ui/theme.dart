import 'package:flutter/material.dart';

ThemeData buildLightTheme() {
  const colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFB45309),
    onPrimary: Colors.white,
    secondary: Color(0xFFFFBB8A),
    onSecondary: Color(0xFF1F2937),
    error: Color(0xFFB00020),
    onError: Colors.white,
    surface: Color(0xFFFFFBF6),
    onSurface: Color(0xFF1F2937),
  );

  return ThemeData(
    useMaterial3: true,
    fontFamily: 'InstrumentSans',
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      backgroundColor: Color(0xFFFFFBF6),
      foregroundColor: Color(0xFF1F2937),
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Color(0xFF1F2937),
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFFFFBF6),
      selectedItemColor: Color(0xFFB45309),
      unselectedItemColor: Color(0xFF6B7280),
      type: BottomNavigationBarType.fixed,
    ),
  );
}

ThemeData buildDarkTheme() {
  const colorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFFB36A),
    onPrimary: Color(0xFF2A1D10),
    secondary: Color(0xFF8B5E34),
    onSecondary: Colors.white,
    error: Color(0xFFCF6679),
    onError: Color(0xFF1E1E1E),
    surface: Color(0xFF121212),
    onSurface: Color(0xFFEAEAEA),
  );

  return ThemeData(
    useMaterial3: true,
    fontFamily: 'InstrumentSans',
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      backgroundColor: Color(0xFF121212),
      foregroundColor: Color(0xFFEAEAEA),
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Color(0xFFEAEAEA),
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1D1D1D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 0,
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFF2F2F2F)),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF121212),
      selectedItemColor: Color(0xFFFFB36A),
      unselectedItemColor: Color(0xFF9CA3AF),
      type: BottomNavigationBarType.fixed,
    ),
  );
}
