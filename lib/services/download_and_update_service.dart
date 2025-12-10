import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadAndUpdateApkService {
  final Dio _dio = GetIt.instance<Dio>();
  final talker = GetIt.instance<Talker>();

  Future<void> downloadAndPrepareUpdate(
    BuildContext context,
    String zipUrl, {
    required ValueNotifier<double> progressNotifier,
  }) async {
    try {
      // permission check
      final hasPermission = await _checkInstallPermission(context);
      if (!hasPermission) {
        talker.error("Install permission denied");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Need permission for installing")),
          );
        }
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final zipPath = "${tempDir.path}/update.zip";
      final extractDir = Directory("${tempDir.path}/update");

      if (extractDir.existsSync()) {
        extractDir.deleteSync(recursive: true);
      }
      extractDir.createSync();

      talker.info("Downloading ZIP: $zipUrl");

      // download zip archive
      await _dio.download(
        zipUrl,
        zipPath,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            progressNotifier.value = received / total;
          }
        },
      );

      talker.info("ZIP downloaded: $zipPath");

      // unpack
      await ZipFile.extractToDirectory(
        zipFile: File(zipPath),
        destinationDir: extractDir,
      );

      talker.info("ZIP extracted: ${extractDir.path}");

      // recursively searching APK
      final apkFile = _findApkRecursive(extractDir);
      if (apkFile == null) {
        throw Exception("APK not found in archive!");
      }

      talker.info("APK found: ${apkFile.path}");
      progressNotifier.value = 0;
      // show install dialog
      if (context.mounted) {
        _showInstallDialog(context, apkFile);
      }
    } catch (e, st) {
      talker.handle(e, st, "[DownloadAndUpdateApkService Error]");

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Updating Error: $e")));
      }
    }
  }

  // check and request install permission
  Future<bool> _checkInstallPermission(BuildContext context) async {
    if (!Platform.isAndroid) return true;

    try {
      var status = await Permission.requestInstallPackages.status;
      talker.info("Install permission status: $status");

      if (!status.isGranted) {
        // show explanation dialog
        if (context.mounted) {
          final shouldRequest = await _showPermissionDialog(context);
          if (!shouldRequest) return false;
        }

        // request permission
        status = await Permission.requestInstallPackages.request();
        talker.info("Permission request result: $status");

        if (status.isPermanentlyDenied && context.mounted) {
          // if user denied forever, show settings dialog
          await _showOpenSettingsDialog(context);
          return false;
        }

        return status.isGranted;
      }

      return true;
    } catch (e, st) {
      talker.handle(e, st, "[Permission Check Error]");
      // trying to install even if theres error
      return true;
    }
  }

  /// explanation dialogue
  Future<bool> _showPermissionDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Installing permission"),
            content: const Text(
              "Need installing permission for "
              "installing new version of the app.",
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

  /// settings opening dialogue
  Future<void> _showOpenSettingsDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Open settings"),
        content: const Text(
          "Access denied. Please, enable app installing "
          "in system settings.",
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

  /// searching APK
  File? _findApkRecursive(Directory dir) {
    for (final entity in dir.listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith(".apk")) {
        return entity;
      }
    }
    return null;
  }

  void _showInstallDialog(BuildContext context, File apkFile) {
    talker.info("Showing install dialog");

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Update is ready"),
          content: const Text(
            "New version downloaded. Click «Install», for update.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                talker.info("User cancelled update installing.");
                Navigator.of(dialogContext).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _installApk(apkFile);
              },
              child: const Text("Install"),
            ),
          ],
        );
      },
    );
  }

  /// install APK
  Future<void> _installApk(File apkFile) async {
    try {
      talker.info("Opening APK: ${apkFile.path}");
      talker.info("APK exists: ${apkFile.existsSync()}");
      talker.info("APK size: ${apkFile.lengthSync()} bytes");

      final result = await OpenFilex.open(
        apkFile.path,
        type: "application/vnd.android.package-archive",
        uti: "application/vnd.android.package-archive",
      );

      talker.info("OpenFilex result: ${result.type} | ${result.message}");

      // if failed, trying alternative method
      if (result.type != ResultType.done) {
        talker.warning("OpenFilex failed!");
        // Можно добавить альтернативный метод через intent
      }
    } catch (e, st) {
      talker.handle(e, st, "[Install APK Error]");
    }
  }
}
