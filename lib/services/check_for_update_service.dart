import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:ManasYemek/models/models.dart';

class CheckForUpdateService {
  final _talker = GetIt.instance<Talker>();
  final _remoteConfig = FirebaseRemoteConfig.instance;

  CheckForUpdateService() {
    // Устанавливаем значения по умолчанию и настройки кеширования
    _remoteConfig.setDefaults({
      "latest_version": "1.0.0",
      "update_required": false,
      "update_url": "",
      "update_changelog": "Initial release.",
    });
    // Устанавливаем, как часто приложение будет запрашивать новые значения с сервера
    // (например, раз в час, чтобы не делать это при каждом запуске)
    _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
  }

  static const String versionJsonUrl =
      "https://raw.githubusercontent.com/Atoktobekov/yemekManas/test/version.json";

  // main method
  Future<UpdateInfo?> checkForUpdate() async {
    try {
      // 1. Получаем свежие значения с сервера Firebase
      await _remoteConfig.fetchAndActivate();

      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      // 2. Получаем значения из Remote Config
      final latestVersion = _remoteConfig.getString("latest_version");
      final updateRequired = _remoteConfig.getBool("update_required");
      final updateUrl = _remoteConfig.getString("update_url");
      final changelog = _remoteConfig.getString("update_changelog"); // Новое поле!

      _talker.info("Remote Config data: version=$latestVersion, required=$updateRequired");

      if (latestVersion.isEmpty || updateUrl.isEmpty) return null;

      if (_isNewerVersion(latestVersion, currentVersion)) {
        return UpdateInfo(
          latestVersion: latestVersion,
          isForceUpdate: updateRequired,
          updateUrl: updateUrl,
          changelog: changelog, // Передаем changelog в UI
        );
      }
    } catch (e, st) {
      _talker.handle(e, st, "[CheckForUpdateService Error]");
    }
    return null;
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
}
