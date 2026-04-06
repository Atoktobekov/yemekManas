import 'package:ManasYemek/core/localization/app_localizations.dart';
import 'package:ManasYemek/shared/presentation/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _version = '-';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() => _version = '${info.version}+${info.buildNumber}');
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.tr('settings'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(context.l10n.tr('theme'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(value: ThemeMode.system, label: Text(context.l10n.tr('themeSystem'))),
              ButtonSegment(value: ThemeMode.light, label: Text(context.l10n.tr('themeLight'))),
              ButtonSegment(value: ThemeMode.dark, label: Text(context.l10n.tr('themeDark'))),
            ],
            selected: {settings.themeMode},
            onSelectionChanged: (selected) => settings.setThemeMode(selected.first),
          ),
          const SizedBox(height: 24),
          Text(context.l10n.tr('language'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'system', label: Text(context.l10n.tr('languageSystem'))),
              const ButtonSegment(value: 'en', label: Text('English')),
              const ButtonSegment(value: 'ru', label: Text('Русский')),
              const ButtonSegment(value: 'tr', label: Text('Türkçe')),
            ],
            selected: {settings.locale?.languageCode ?? 'system'},
            onSelectionChanged: (selected) {
              final lang = selected.first;
              if (lang == 'system') {
                settings.setLocale(null);
              } else {
                settings.setLocale(Locale(lang));
              }
            },
          ),
          const SizedBox(height: 24),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(context.l10n.tr('version')),
            subtitle: Text(_version),
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.tr('madeForManas'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
