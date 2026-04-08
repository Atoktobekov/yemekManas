import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class ThemeModeController extends ChangeNotifier {
  static const themeModeKey = 'theme_mode';

  final Box<String> _settingsBox;
  ThemeMode _themeMode;

  ThemeModeController({
    required Box<String> settingsBox,
    required ThemeMode initialThemeMode,
  })  : _settingsBox = settingsBox,
        _themeMode = initialThemeMode;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Иконка отражает текущее состояние:
  /// system → brightness_auto, light → dark_mode, dark → light_mode
  IconData get themeIcon => _themeMode == ThemeMode.dark
      ? Icons.light_mode
      : Icons.dark_mode;

  Future<void> toggleThemeMode() async {
    _themeMode = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;

    await _settingsBox.put(themeModeKey, _themeMode.name);
    notifyListeners();
  }

  static ThemeMode themeModeFromString(String? value) {
    return switch (value) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.light, // дефолт теперь light
    };
  }
}