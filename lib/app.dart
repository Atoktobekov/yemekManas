import 'package:ManasYemek/repositories/menu_repository.dart';
import 'package:ManasYemek/theme/theme.dart';
import 'package:ManasYemek/view/menu_screen.dart';
import 'package:ManasYemek/view_models/menu_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class YemekApp extends StatelessWidget {
  const YemekApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const MenuScreen(),
      ),
    );
  }
}