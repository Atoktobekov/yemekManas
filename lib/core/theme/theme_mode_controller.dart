import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class ThemeModeController extends ChangeNotifier {
  static const themeModeKey = 'theme_mode';

  final Box<String> _settingsBox;

  ThemeMode _themeMode;

  ThemeModeController({
    required Box<String> settingsBox,
    required ThemeMode initialThemeMode,
  }) : _settingsBox = settingsBox,
       _themeMode = initialThemeMode;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> toggleThemeMode() async {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    await _settingsBox.put(themeModeKey, _themeMode.name);
    notifyListeners();
  }

  static ThemeMode themeModeFromString(String? value) {
    return switch (value) {
      ThemeMode.dark.name => ThemeMode.dark,
      ThemeMode.system.name => ThemeMode.system,
      _ => ThemeMode.light,
    };
  }
}
