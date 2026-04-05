import 'package:ManasYemek/shared/presentation/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SettingsProvider', () {
    test('theme mode changes and notifies listeners', () {
      final provider = SettingsProvider();
      var notifications = 0;

      provider.addListener(() => notifications++);
      provider.setThemeMode(ThemeMode.dark);

      expect(provider.themeMode, ThemeMode.dark);
      expect(notifications, 1);
    });

    test('locale changes and notifies listeners', () {
      final provider = SettingsProvider();
      var notifications = 0;

      provider.addListener(() => notifications++);
      provider.setLocale(const Locale('ru'));

      expect(provider.locale, const Locale('ru'));
      expect(notifications, 1);
    });
  });
}
