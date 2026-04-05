import 'package:ManasYemek/core/di/service_locator.dart';
import 'package:ManasYemek/core/localization/app_localizations.dart';
import 'package:ManasYemek/core/ui/theme.dart';
import 'package:ManasYemek/features/buffet/presentation/providers/buffet_provider.dart';
import 'package:ManasYemek/features/menu/presentation/providers/menu_provider.dart';
import 'package:ManasYemek/features/update/presentation/providers/update_provider.dart';
import 'package:ManasYemek/root_page.dart';
import 'package:ManasYemek/shared/presentation/providers/settings_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class YemekApp extends StatelessWidget {
  const YemekApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider.fromGetIt()),
        ChangeNotifierProvider(create: (_) => UpdateProvider.fromGetIt()),
        ChangeNotifierProvider(create: (_) => BuffetProvider.fromGetIt()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (_, settings, __) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildLightTheme(),
          darkTheme: buildDarkTheme(),
          themeMode: settings.themeMode,
          locale: settings.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          navigatorObservers: [
            getIt<FirebaseAnalyticsObserver>(),
          ],
          home: const RootPage(),
        ),
      ),
    );
  }
}
