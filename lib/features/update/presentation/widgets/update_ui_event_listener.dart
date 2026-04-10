import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:ManasYemek/features/update/domain/entities/update_info_entity.dart';
import 'package:ManasYemek/features/update/presentation/events/update_ui_event.dart';
import 'package:ManasYemek/features/update/presentation/providers/update_provider.dart';

class UpdateUiEventListener extends StatefulWidget {
  final Widget child;

  const UpdateUiEventListener({super.key, required this.child});

  @override
  State<UpdateUiEventListener> createState() => _UpdateUiEventListenerState();
}

class _UpdateUiEventListenerState extends State<UpdateUiEventListener> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<UpdateProvider>().uiEvent.addListener(_handleUiEvents);
    });
  }

  @override
  void dispose() {
    context.read<UpdateProvider>().uiEvent.removeListener(_handleUiEvents);
    super.dispose();
  }

  void _handleUiEvents() {
    final updateProvider = context.read<UpdateProvider>();
    final event = updateProvider.uiEvent.value;
    if (event == null || !mounted) return;

    if (event is ShowUpdateDialog) {
      _showUpdateDialog(context, event.updateInfo);
    } else if (event is ShowPermissionExplanation) {
      _showPermissionExplanationDialog(context).then((isConfirmed) {
        if (isConfirmed) {
          updateProvider.proceedWithPermissionRequest(url: event.url, latestVersion: event.latestVersion);
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

    updateProvider.uiEvent.value = null;
  }

  @override
  Widget build(BuildContext context) => widget.child;

  void _showUpdateDialog(BuildContext context, UpdateInfoEntity updateInfo) {
    final updateProvider = context.read<UpdateProvider>();
    showDialog(
      barrierDismissible: !updateInfo.isForceUpdate,
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Доступно обновление'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Новая версия: ${updateInfo.latestVersion}'),
            if (updateInfo.changelog.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                "Что нового:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              // if changelog is too long — wrap with scroll
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: SingleChildScrollView(
                  child: Text(updateInfo.changelog),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (!updateInfo.isForceUpdate)
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Позже'),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              updateProvider.requestPermissionAndStartDownload(url: updateInfo.updateUrl, latestVersion: updateInfo.latestVersion);
            },
            child: const Text('Обновить'),
          ),
        ],
      ),
    );
  }

 /* void _showUpdateDialog(BuildContext context, UpdateInfoEntity updateInfo) {
    final updateProvider = context.read<UpdateProvider>();
    showDialog(
      barrierDismissible: !updateInfo.isForceUpdate,
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Update is available'),
        content: Text('New version available: ${updateInfo.latestVersion}'),
        actions: [
          if (!updateInfo.isForceUpdate)
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Later'),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              updateProvider.requestPermissionAndStartDownload(
                updateInfo.updateUrl,
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }*/

  Future<bool> _showPermissionExplanationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Разрешение на установку'),
            content: const Text(
              'Необходимо разрешение для установки новой версии.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Разрешить'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showInstallDialog(BuildContext context, File apkFile) {
    final updateProvider = context.read<UpdateProvider>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Обновление готово'),
        content: const Text('Новая версия загружена. Нажмите установить.'),
        actions: [
          /// I commented this line cause I think its not necessary
          /// to give a user option to cancel update if he's already accepted
          /// install request
          //TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              updateProvider.installApk(apkFile);
            },
            child: const Text('Установить'),
          ),
        ],
      ),
    );
  }

  void _showOpenSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Открыть настройки'),
        content: const Text(
          'Разрешение отклонено. Пожалуйста, включите установку из этого источника в настройках.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
            child: const Text('Настройки'),
          ),
        ],
      ),
    );
  }
}
