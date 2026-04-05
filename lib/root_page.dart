import 'package:ManasYemek/core/localization/app_localizations.dart';
import 'package:ManasYemek/features/buffet/presentation/screens/buffet_screen.dart';
import 'package:ManasYemek/features/menu/presentation/screens/menu_screen.dart';
import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = const [
      MenuScreen(),
      BuffetScreen(),
    ];
  }

  void _onItemTapped(int index) {
    if (_currentIndex == index) return;
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFFFFBB8A),
        backgroundColor: Theme.of(context).colorScheme.surface,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.restaurant),
            label: context.l10n.tr('tabCanteen'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.local_cafe),
            label: context.l10n.tr('tabBuffet'),
          ),
        ],
      ),
    );
  }
}
