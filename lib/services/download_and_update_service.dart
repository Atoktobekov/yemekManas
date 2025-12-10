import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:ManasYemek/exceptions/exceptions.dart';

class DownloadAndUpdateApkService {
  final Dio _dio;
  final Talker talker;

  DownloadAndUpdateApkService({required Dio dio, required this.talker})
    : _dio = dio;

  Future<File?> downloadAndPrepareUpdate(
    String zipUrl, {
    required ValueNotifier<double> progressNotifier,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final zipPath = "${tempDir.path}/update.zip";
    final extractDir = Directory("${tempDir.path}/update");

    try {
      if (extractDir.existsSync()) {
        extractDir.deleteSync(recursive: true);
      }
      extractDir.createSync();

      talker.info("Downloading ZIP: $zipUrl");

      await _downloadWithRetry(zipUrl, zipPath, progressNotifier);
      progressNotifier.value = 1.0;

      talker.info("ZIP downloaded: $zipPath");

      await ZipFile.extractToDirectory(
        zipFile: File(zipPath),
        destinationDir: extractDir,
      );

      talker.info("ZIP extracted: ${extractDir.path}");

      final apkFile = await _findApkRecursive(extractDir);
      if (apkFile == null) {
        throw ApkNotFoundException();
      }

      talker.info("APK found: ${apkFile.path}");
      return apkFile;
    } catch (e, st) {
      talker.handle(e, st, "[DownloadAndUpdateApkService Error]");
      rethrow;
    } finally {
      progressNotifier.value = 0.0;
      if (File(zipPath).existsSync()) {
        File(zipPath).deleteSync();
      }
    }
  }

  Future<File?> _findApkRecursive(Directory dir) async {
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith(".apk")) {
        return entity;
      }
    }
    return null;
  }

  Future<void> installApk(File apkFile) async {
    try {
      talker.info("Opening APK: ${apkFile.path}");
      if (!await apkFile.exists()) {
        talker.error(
          "Install failed: APK file does not exist at ${apkFile.path}",
        );
        throw Exception("APK file not found.");
      }

      final result = await OpenFilex.open(
        apkFile.path,
        type: "application/vnd.android.package-archive",
      );
      talker.info("OpenFilex result: ${result.type} | ${result.message}");

      if (result.type != ResultType.done) {
        talker.warning("OpenFilex failed: ${result.message}");
        throw Exception("Failed to open installer: ${result.message}");
      }
    } catch (e, st) {
      talker.handle(e, st, "[Install APK Error]");
      rethrow;
    }
  }

  Future<void> _downloadWithRetry(
    String url,
    String savePath,
    ValueNotifier<double> progressNotifier, {
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 2),
  }) async {
    int attempt = 0;
    while (attempt < maxRetries) {
      try {
        attempt++;
        talker.info("Downloading ZIP (attempt $attempt): $url");
        await _dio.download(
          url,
          savePath,
          onReceiveProgress: (received, total) {
            if (total > 0) {
              progressNotifier.value = received / total;
            }
          },
        );
        talker.info("ZIP downloaded successfully: $savePath");
        return;
      } catch (e) {
        talker.warning("Download attempt $attempt failed: $e");
        if (attempt >= maxRetries) rethrow;
        await Future.delayed(retryDelay);
      }
    }
  }
}


