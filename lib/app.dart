import 'package:ManasYemek/core/di/service_locator.dart';
import 'package:ManasYemek/core/theme/theme_mode_controller.dart';
import 'package:ManasYemek/features/buffet/presentation/providers/buffet_provider.dart';
import 'package:ManasYemek/root_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ManasYemek/features/menu/presentation/providers/menu_provider.dart';
import 'package:ManasYemek/features/update/presentation/providers/update_provider.dart';
import 'package:ManasYemek/core/ui/theme.dart';

class YemekApp extends StatelessWidget {
  const YemekApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeModeController>.value(value: getIt<ThemeModeController>()),
        ChangeNotifierProvider(create: (_) => MenuProvider.fromGetIt()),
        ChangeNotifierProvider(create: (_) => UpdateProvider.fromGetIt()),
        ChangeNotifierProvider(create: (_) => BuffetProvider.fromGetIt()),
      ],
      child: Consumer<ThemeModeController>(
        builder: (context, themeController, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildLightTheme(),
          darkTheme: buildDarkTheme(),
          themeMode: themeController.themeMode,
          navigatorObservers: [
            getIt<FirebaseAnalyticsObserver>(),
          ],
          home: const RootPage(),
        ),
      ),
    );
  }
}
