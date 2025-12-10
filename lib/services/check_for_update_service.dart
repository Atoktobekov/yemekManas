import 'package:ManasYemek/services/services.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class CheckForUpdateService {
  final Dio _dio = GetIt.instance<Dio>();
  final ValueNotifier<double> progressNotifier;

  static const String versionJsonUrl =
      "https://raw.githubusercontent.com/Atoktobekov/yemekManas/test/version.json";

  CheckForUpdateService({required this.progressNotifier});

  /// main method
  Future<void> checkForUpdate(BuildContext context) async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final response = await _dio.get(versionJsonUrl);

      final Map<String, dynamic> data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      GetIt.instance<Talker>().info(
        "VERSION JSON RESPONSE: ${response.data.runtimeType}",
      );
      GetIt.instance<Talker>().info("VERSION JSON DATA: ${response.data}");
      final latestVersion = data["latest_version"]?.toString();
      final updateRequired = data["update_required"] ?? false;
      final updateUrl = data["update_url"] ?? "";

      if (latestVersion == null || latestVersion.isEmpty) return;

      if (_isNewerVersion(latestVersion, currentVersion)) {
        _showUpdateDialog(
          context,
          latestVersion: latestVersion,
          force: updateRequired,
          url: updateUrl,
        );
      }
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st, "[CheckForUpdateService Error]");
    }
  }

  bool _isNewerVersion(String server, String local) {
    try {
      List<int> s = server.split('.').map((e) => int.parse(e)).toList();
      List<int> l = local.split('.').map((e) => int.parse(e)).toList();

      for (int i = 0; i < 3; i++) {
        if (s[i] > l[i]) return true;
        if (s[i] < l[i]) return false;
      }
    } catch (_) {
      return false; // if format is wrong, return false as no update
    }

    return false;
  }

  /// update dialogue
  void _showUpdateDialog(
    BuildContext parentContext, { // <-- screen context
    required String latestVersion,
    required bool force,
    required String url,
  }) {
    showDialog(
      barrierDismissible: !force,
      context: parentContext,
      builder: (dialogContext) {
        return WillPopScope(
          onWillPop: () async => !force,
          child: AlertDialog(
            title: const Text("Update is available"),
            content: Text("New version available: $latestVersion"),
            actions: [
              if (!force)
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text("Later"),
                ),
              TextButton(
                onPressed: () async {
                  Navigator.of(dialogContext).pop();

                  final downloadService = DownloadAndUpdateApkService();
                  await downloadService.downloadAndPrepareUpdate(
                    parentContext, // <-- ВАЖНО: передаём экранный контекст
                    url,
                    progressNotifier: progressNotifier,
                  );
                },
                child: const Text("Update"),
              ),
            ],
          ),
        );
      },
    );
  }
}
