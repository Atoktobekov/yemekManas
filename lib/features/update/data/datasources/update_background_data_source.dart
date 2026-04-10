import 'dart:async';
import 'dart:io';

import 'package:ManasYemek/core/error/exceptions.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talker_flutter/talker_flutter.dart';

class UpdateBackgroundDataSource {
  final Talker talker;

  UpdateBackgroundDataSource({required this.talker});

  Future<String> enqueueDownload(String url) async {
    final baseDir = await _ensureBaseDir();

    talker.info('[UpdateBackgroundDataSource] enqueue download: $url');

    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: baseDir.path,
      fileName: 'update_bundle.zip',
      showNotification: true,
      openFileFromNotification: false,
      requiresStorageNotLow: true,
    );

    if (taskId == null) {
      throw Exception('Не удалось создать задачу загрузки');
    }

    return taskId;
  }

  Future<List<DownloadTask>> loadTasks() async {
    final tasks = (await FlutterDownloader.loadTasks()) ?? <DownloadTask>[];
    return tasks;
  }

  Future<void> removeTask(String taskId) async {
    talker.info('[UpdateBackgroundDataSource] remove task: $taskId');
    await FlutterDownloader.remove(taskId: taskId, shouldDeleteContent: false);
  }

  Future<String?> resumeTask(String taskId) async {
    try {
      return await FlutterDownloader.resume(taskId: taskId);
    } catch (e, st) {
      talker.handle(e, st, '[UpdateBackgroundDataSource] resume failed');
      return null;
    }
  }

  Future<String?> retryTask(String taskId) async {
    try {
      return await FlutterDownloader.retry(taskId: taskId);
    } catch (e, st) {
      talker.handle(e, st, '[UpdateBackgroundDataSource] retry failed');
      return null;
    }
  }

  Future<File> extractZipToApk({required String zipPath}) async {
    final zip = File(zipPath);
    if (!zip.existsSync()) {
      throw Exception('Архив обновления не найден');
    }

    final baseDir = await _ensureBaseDir();
    final extractDir = Directory('${baseDir.path}/extracted');

    if (extractDir.existsSync()) {
      await extractDir.delete(recursive: true);
    }
    await extractDir.create(recursive: true);

    talker.info('[UpdateBackgroundDataSource] extracting zip: $zipPath');
    await ZipFile.extractToDirectory(zipFile: zip, destinationDir: extractDir);

    final apk = await _findApkRecursive(extractDir);
    if (apk == null) {
      throw ApkNotFoundException();
    }
    return apk;
  }

  Future<Directory> _ensureBaseDir() async {
    final temp = await getTemporaryDirectory();
    final base = Directory('${temp.path}/update_pipeline');
    if (!base.existsSync()) {
      await base.create(recursive: true);
    }
    return base;
  }

  Future<File?> _findApkRecursive(Directory dir) async {
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File && entity.path.toLowerCase().endsWith('.apk')) {
        return entity;
      }
    }
    return null;
  }
}
