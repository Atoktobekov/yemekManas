import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:ManasYemek/models/models.dart';

class CheckForUpdateService {
  final Dio _dio;
  final Talker talker;
  final ValueNotifier<double> progressNotifier;

  CheckForUpdateService({
    required Dio dio,
    required this.talker,
    required this.progressNotifier,
  }) : _dio = dio;

  static const String versionJsonUrl =
      "https://raw.githubusercontent.com/Atoktobekov/yemekManas/test/version.json";

  // main method
  Future<UpdateInfo?> checkForUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final response = await _dio.get(versionJsonUrl);

      final Map<String, dynamic> data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      talker.info("VERSION JSON RESPONSE: ${response.data.runtimeType}");
      talker.info("VERSION JSON DATA: ${response.data}");

      final latestVersion = data["latest_version"]?.toString();
      final updateRequired = data["update_required"] ?? false;
      final updateUrl = data["update_url"] ?? "";

      if (latestVersion == null || latestVersion.isEmpty) return null;

      if (_isNewerVersion(latestVersion, currentVersion)) {
        return UpdateInfo(
          latestVersion: latestVersion,
          isForceUpdate: updateRequired,
          updateUrl: updateUrl,
        );
      }
    } on DioException {
      talker.error("[CheckForUpdateService Error] \n No internet connection");
    } catch (e, st) {
      talker.handle(e, st, "[CheckForUpdateService Error]");
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
