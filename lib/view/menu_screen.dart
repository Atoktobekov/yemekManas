import 'dart:async';
import 'dart:io';

import 'package:ManasYemek/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:ManasYemek/view_models/menu_view_model.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:ManasYemek/models/models.dart';
import 'package:ManasYemek/view_models/helpers/helpers.dart';

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


  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final viewModel = context.read<MenuViewModel>();

      viewModel.uiEvent.addListener(_handleUiEvents);

      if (viewModel.status == MenuStatus.initial) {
        viewModel.fetchMenu();
      }

      viewModel.checkForUpdate();
    });
  }

  @override
  void dispose() {
    _logButtonTimer?.cancel();

    context.read<MenuViewModel>().uiEvent.removeListener(_handleUiEvents);
    _fadeController.dispose();
    super.dispose();
  }

  // UI events handler
  void _handleUiEvents() {
    final viewModel = context.read<MenuViewModel>();
    final event = viewModel.uiEvent.value;
    if (event == null || !mounted) return;

    if (event is ShowUpdateDialog) {
      _showUpdateDialog(context, event.updateInfo);
    } else if (event is ShowPermissionExplanation) {
      _showPermissionExplanationDialog(context).then((userAgreed) {
        if (userAgreed) {
          viewModel.proceedWithPermissionRequest(event.url);
        }
      });
    } else if (event is ShowInstallDialog) {
      _showInstallDialog(context, event.apkFile);
    } else if (event is ShowOpenSettingsDialog) {
      _showOpenSettingsDialog(context);
    } else if (event is ShowSnackbar) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(event.message)));
    }
    viewModel.uiEvent.value = null;
  }

  void _handleLogButtonTap() {
    _logButtonTapCount++;

    _logButtonTimer?.cancel();
    _logButtonTimer = Timer(const Duration(seconds: 1), () {
      _logButtonTapCount = 0;
    });

    if (_logButtonTapCount == 3) {
      _logButtonTapCount = 0;
      _logButtonTimer?.cancel();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TalkerScreen(talker: GetIt.instance<Talker>()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MenuViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:Stack(
          alignment: Alignment.centerRight,
          children: [
            const Center(
              child: Text(
                'Yemekhane Menu',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            GestureDetector(
              onTap: _handleLogButtonTap,
              child: Container(
                width: 50,
                height: 50,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
      body: Builder(
        builder: (context) {
          if (viewModel.status == MenuStatus.loaded) {
            if (!_fadeController.isCompleted) _fadeController.forward();
          } else {
            _fadeController.reset();
          }

          switch (viewModel.status) {
            case MenuStatus.initial:
            case MenuStatus.loading:
              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                itemCount: 3,
                separatorBuilder: (_, _) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  child: Divider(thickness: 1, color: Colors.grey),
                ),
                itemBuilder: (_, _) => const DayMenuSkeleton(),
              );

            case MenuStatus.error:
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          viewModel.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFAEEDD),
                          foregroundColor: Colors.black,
                        ),
                        onPressed: viewModel.fetchMenu,
                        child: const Text(
                          'Try again',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );

            case MenuStatus.loaded:
              return RefreshIndicator(
                onRefresh: () async {
                  _fadeController.reset();
                  await viewModel.fetchMenu();
                },
                child: Column(
                  children: [
                    if (viewModel.isCached)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          left: 12.0,
                          right: 6.0,
                        ),
                        child: Text(
                          viewModel.message,
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 20,
                        ),
                        itemCount: viewModel.menus.length,
                        separatorBuilder: (context, index) => const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 32,
                          ),
                          child: Divider(thickness: 1, color: Colors.grey),
                        ),
                        itemBuilder: (context, index) {
                          return StaggeredDayMenuWidget(
                            dayMenu: viewModel.menus[index],
                            index: index,
                            animation: _fadeAnimation,
                          );
                        },
                      ),
                    ),
                    ValueListenableBuilder<double>(
                      valueListenable: viewModel.downloadProgress,
                      builder: (context, value, _) {
                        if (value == 0 || value == 1) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          children: [
                            LinearProgressIndicator(
                              value: value,
                              minHeight: 4,
                              backgroundColor: Colors.grey[300],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.blue,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 12, top: 7),
                              child: Center(
                                child: Text(
                                  "Downloading new version...",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }

  /// Methods for app updating
  void _showUpdateDialog(BuildContext context, UpdateInfo updateInfo) {
    final viewModel = context.read<MenuViewModel>();
    showDialog(
      barrierDismissible: !updateInfo.isForceUpdate,
      context: context,
      builder: (dialogContext) => WillPopScope(
        onWillPop: () async => !updateInfo.isForceUpdate,
        child: AlertDialog(
          title: const Text("Update is available"),
          content: Text("New version available: ${updateInfo.latestVersion}"),
          actions: [
            if (!updateInfo.isForceUpdate)
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text("Later"),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                viewModel.requestPermissionAndStartDownload(
                  updateInfo.updateUrl,
                );
              },
              child: const Text("Update"),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showPermissionExplanationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Installing permission"),
            content: const Text(
              "Need installing permission for installing new version of the app.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Access"),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showInstallDialog(BuildContext context, File apkFile) {
    final viewModel = context.read<MenuViewModel>();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Update is ready"),
        content: const Text(
          "New version downloaded. Click «Install», for update.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              viewModel.installApk(apkFile);
            },
            child: const Text("Install"),
          ),
        ],
      ),
    );
  }

  void _showOpenSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Open settings"),
        content: const Text(
          "Access denied. Please, enable app installing in system settings.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
            child: const Text("Settings"),
          ),
        ],
      ),
    );
  }
}
