import 'package:ManasYemek/core/di/service_locator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ManasYemek/features/menu/presentation/providers/menu_provider.dart';
import 'package:ManasYemek/features/menu/presentation/screens/menu_screen.dart';
import 'package:ManasYemek/features/update/presentation/providers/update_provider.dart';
import 'package:ManasYemek/core/ui/theme.dart';

class YemekApp extends StatelessWidget {
  const YemekApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuProvider.fromGetIt()),
        ChangeNotifierProvider(create: (_) => UpdateProvider.fromGetIt()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        navigatorObservers: [
          getIt<FirebaseAnalyticsObserver>(),
        ],
        home: const MenuScreen(),
      ),
    );
  }
}
