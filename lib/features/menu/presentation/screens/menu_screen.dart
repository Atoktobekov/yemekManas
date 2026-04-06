import 'dart:async';

import 'package:ManasYemek/core/localization/app_localizations.dart';
import 'package:ManasYemek/features/menu/presentation/providers/menu_provider.dart';
import 'package:ManasYemek/features/menu/presentation/widgets/day_menu_skeleton.dart';
import 'package:ManasYemek/features/menu/presentation/widgets/staggered_day_menu_card.dart';
import 'package:ManasYemek/features/update/presentation/providers/update_provider.dart';
import 'package:ManasYemek/features/update/presentation/widgets/update_download_progress.dart';
import 'package:ManasYemek/features/update/presentation/widgets/update_ui_event_listener.dart';
import 'package:ManasYemek/shared/presentation/providers/settings_provider.dart';
import 'package:ManasYemek/shared/presentation/screens/error_screen.dart';
import 'package:ManasYemek/shared/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:talker_flutter/talker_flutter.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  int _logButtonTapCount = 0;
  Timer? _logButtonTimer;
  String? _lastRequestedLocaleCode;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final menuProvider = context.read<MenuProvider>();
      final updateProvider = context.read<UpdateProvider>();
      final settings = context.read<SettingsProvider>();
      final localeCode = settings.locale?.languageCode ?? Localizations.localeOf(context).languageCode;

      _lastRequestedLocaleCode = localeCode;
      if (menuProvider.status == MenuStatus.initial) {
        menuProvider.fetchMenu(localeCode: localeCode);
      }
      updateProvider.checkForUpdate();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = context.read<SettingsProvider>();
    final localeCode = settings.locale?.languageCode ?? Localizations.localeOf(context).languageCode;

    if (_lastRequestedLocaleCode != null && _lastRequestedLocaleCode != localeCode) {
      _lastRequestedLocaleCode = localeCode;
      context.read<MenuProvider>().fetchMenu(localeCode: localeCode);
    }
  }

  @override
  void dispose() {
    _logButtonTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  void _handleLogButtonTap() {
    _logButtonTapCount++;
    _logButtonTimer?.cancel();
    _logButtonTimer = Timer(const Duration(seconds: 1), () => _logButtonTapCount = 0);

    if (_logButtonTapCount == 3) {
      _logButtonTapCount = 0;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => TalkerScreen(talker: GetIt.instance<Talker>()),
        ),
      );
    }
  }

  Future<void> _openSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = context.watch<MenuProvider>();

    return UpdateUiEventListener(
      child: Scaffold(
        appBar: AppBar(
          title: Stack(
            alignment: Alignment.centerRight,
            children: [
              Center(
                child: Text(
                  context.l10n.tr('appTitleMenu'),
                  style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: _openSettings,
                  ),
                  GestureDetector(
                    onTap: _handleLogButtonTap,
                    child: Container(width: 28, height: 28, color: Colors.transparent),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Builder(
          builder: (_) {
            if (menuProvider.status == MenuStatus.loaded) {
              if (!_fadeController.isCompleted) _fadeController.forward();
            } else {
              _fadeController.reset();
            }

            switch (menuProvider.status) {
              case MenuStatus.initial:
              case MenuStatus.loading:
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  itemCount: 3,
                  separatorBuilder: (_, _) => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    child: Divider(thickness: 1),
                  ),
                  itemBuilder: (_, _) => const DayMenuSkeleton(),
                );
              case MenuStatus.error:
                return ErrorScreen(
                  onRetry: () {
                    final settings = context.read<SettingsProvider>();
                    final localeCode = settings.locale?.languageCode ?? Localizations.localeOf(context).languageCode;
                    menuProvider.fetchMenu(localeCode: localeCode);
                  },
                );
              case MenuStatus.loaded:
                return RefreshIndicator(
                  onRefresh: () async {
                    _fadeController.reset();
                    final settings = context.read<SettingsProvider>();
                    final localeCode = settings.locale?.languageCode ?? Localizations.localeOf(context).languageCode;
                    await menuProvider.fetchMenu(localeCode: localeCode);
                  },
                  child: Column(
                    children: [
                      if (menuProvider.isCached)
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 12, right: 6),
                          child: Text(
                            context.l10n.tr(menuProvider.messageKey),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          itemCount: menuProvider.menus.length,
                          separatorBuilder: (_, _) => const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                            child: Divider(thickness: 1),
                          ),
                          itemBuilder: (_, index) => StaggeredDayMenuCard(
                            dayMenu: menuProvider.menus[index],
                            index: index,
                            animation: _fadeAnimation,
                          ),
                        ),
                      ),
                      const UpdateDownloadProgress(),
                    ],
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
