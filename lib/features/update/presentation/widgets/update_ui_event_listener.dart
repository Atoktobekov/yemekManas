import 'dart:io';

import 'package:ManasYemek/core/localization/app_localizations.dart';
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
          updateProvider.proceedWithPermissionRequest(event.url);
        }
      });
    } else if (event is ShowInstallDialog) {
      _showInstallDialog(context, event.apkFile);
    } else if (event is ShowOpenSettingsDialog) {
      _showOpenSettingsDialog(context);
    } else if (event is ShowSnackbar) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.tr(event.message))));
    }

    updateProvider.uiEvent.value = null;
  }

  @override
  Widget build(BuildContext context) => widget.child;

  void _showUpdateDialog(BuildContext context, UpdateInfoEntity updateInfo) {
    final l10n = context.l10n;
    final updateProvider = context.read<UpdateProvider>();
    showDialog(
      barrierDismissible: !updateInfo.isForceUpdate,
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.tr('updateAvailable')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${l10n.tr('newVersion')}: ${updateInfo.latestVersion}'),
            if (updateInfo.changelog.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                '${l10n.tr('whatsNew')}:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
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
              child: Text(l10n.tr('later')),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              updateProvider.requestPermissionAndStartDownload(updateInfo.updateUrl);
            },
            child: Text(l10n.tr('update')),
          ),
        ],
      ),
    );
  }

  Future<bool> _showPermissionExplanationDialog(BuildContext context) async {
    final l10n = context.l10n;
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(l10n.tr('installPermissionTitle')),
            content: Text(l10n.tr('installPermissionBody')),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.tr('cancel')),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.tr('allow')),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showInstallDialog(BuildContext context, File apkFile) {
    final l10n = context.l10n;
    final updateProvider = context.read<UpdateProvider>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.tr('updateReady')),
        content: Text(l10n.tr('updateReadyBody')),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              updateProvider.installApk(apkFile);
            },
            child: Text(l10n.tr('install')),
          ),
        ],
      ),
    );
  }

  void _showOpenSettingsDialog(BuildContext context) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.tr('openSettings')),
        content: Text(l10n.tr('openSettingsBody')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.tr('cancel')),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
            child: Text(l10n.tr('openSettingsAction')),
          ),
        ],
      ),
    );
  }
}
