import 'dart:async';
import 'dart:io';

import 'package:ManasYemek/features/update/data/datasources/update_background_data_source.dart';
import 'package:ManasYemek/features/update/data/datasources/update_task_local_data_source.dart';
import 'package:ManasYemek/features/update/data/services/update_notification_service.dart';
import 'package:ManasYemek/features/update/domain/entities/update_task_state.dart';
import 'package:ManasYemek/features/update/domain/repositories/update_task_repository.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_filex/open_filex.dart';
import 'package:talker_flutter/talker_flutter.dart';

class UpdateTaskRepositoryImpl implements UpdateTaskRepository {
  final UpdateTaskLocalDataSource localDataSource;
  final UpdateBackgroundDataSource backgroundDataSource;
  final UpdateNotificationService notificationService;
  final Talker talker;

  final StreamController<UpdateTaskState> _controller =
      StreamController.broadcast();
  Timer? _pollTimer;

  UpdateTaskRepositoryImpl({
    required this.localDataSource,
    required this.backgroundDataSource,
    required this.notificationService,
    required this.talker,
  });

  @override
  Future<UpdateTaskState> getSavedState() async {
    return localDataSource.readState();
  }

  @override
  Stream<UpdateTaskState> watchTask() => _controller.stream;

  @override
  Future<UpdateTaskState> startUpdate({
    required String url,
    required String targetVersion,
  }) async {
    final current = localDataSource.readState();
    talker.info('[UpdateTaskRepository] startUpdate requested for v$targetVersion');
    if (_isActive(current.status)) {
      talker.warning('[UpdateTaskRepository] active task already exists: ${current.status.name}');
      return current;
    }

    final queued = UpdateTaskState(
      status: UpdateTaskStatus.queued,
      targetVersion: targetVersion,
      downloadUrl: url,
      progress: 0,
      updatedAt: DateTime.now(),
    );
    await _emitState(queued);

    final taskId = await backgroundDataSource.enqueueDownload(url);
    talker.info('[UpdateTaskRepository] download enqueued: $taskId');
    final downloading = queued.copyWith(
      status: UpdateTaskStatus.downloading,
      downloaderTaskId: taskId,
      progress: 0,
    );
    await _emitState(downloading);
    _startPolling();
    return downloading;
  }

  @override
  Future<UpdateTaskState> recover() async {
    final state = localDataSource.readState();
    talker.info('[UpdateTaskRepository] recovering task with state: ${state.status.name}');
    if (state.status == UpdateTaskStatus.idle) {
      return state;
    }

    final tasks = await backgroundDataSource.loadTasks();
    final task = tasks.where((t) => t.taskId == state.downloaderTaskId).firstOrNull;

    if (task == null) {
      if (state.apkPath != null && File(state.apkPath!).existsSync()) {
        final ready = state.copyWith(
          status: UpdateTaskStatus.readyToInstall,
          progress: 1,
        );
        await _emitState(ready);
        return ready;
      }

      final interrupted = state.copyWith(
        status: UpdateTaskStatus.interrupted,
        failureReason: 'Задача загрузки не найдена. Начните заново.',
      );
      await _emitState(interrupted);
      return interrupted;
    }

    final mapped = await _mapTaskToState(state, task);
    await _emitState(mapped);

    if (mapped.status == UpdateTaskStatus.downloading ||
        mapped.status == UpdateTaskStatus.queued) {
      _startPolling();
    }

    if (mapped.status == UpdateTaskStatus.completed) {
      return finalizeDownloadAndExtract();
    }

    return mapped;
  }

  @override
  Future<UpdateTaskState> finalizeDownloadAndExtract() async {
    final current = localDataSource.readState();
    if (current.downloaderTaskId == null) {
      final failed = current.copyWith(
        status: UpdateTaskStatus.failed,
        failureReason: 'Отсутствует идентификатор загрузки',
      );
      await _emitState(failed);
      return failed;
    }

    talker.info('[UpdateTaskRepository] finalize download and extract');

    final extracting = current.copyWith(
      status: UpdateTaskStatus.extracting,
      failureReason: null,
    );
    await _emitState(extracting);

    try {
      final tasks = await backgroundDataSource.loadTasks();
      final task = tasks
          .where((t) => t.taskId == current.downloaderTaskId)
          .firstOrNull;

      final zipPath = task?.savedDir != null && task?.filename != null
          ? '${task!.savedDir}/${task.filename}'
          : current.zipPath;

      if (zipPath == null) {
        throw Exception('Путь к архиву не найден');
      }

      final apkFile = await backgroundDataSource.extractZipToApk(zipPath: zipPath);
      talker.info('[UpdateTaskRepository] apk extracted: ${apkFile.path}');

      final ready = extracting.copyWith(
        status: UpdateTaskStatus.readyToInstall,
        progress: 1,
        apkPath: apkFile.path,
        zipPath: zipPath,
        failureReason: null,
      );
      await _emitState(ready);

      await backgroundDataSource.removeTask(current.downloaderTaskId!);
      return ready;
    } catch (e, st) {
      talker.handle(e, st, '[UpdateTaskRepository] extract failed');
      final failed = extracting.copyWith(
        status: UpdateTaskStatus.failed,
        failureReason: 'Ошибка распаковки: $e',
      );
      await _emitState(failed);
      return failed;
    }
  }

  @override
  Future<UpdateTaskState> markInstalling() async {
    final current = localDataSource.readState();
    final next = current.copyWith(status: UpdateTaskStatus.installing);
    await _emitState(next);
    return next;
  }

  @override
  Future<void> installApk(File apkFile) async {
    talker.info('[UpdateTaskRepository] install requested for ${apkFile.path}');
    if (!await apkFile.exists()) {
      throw Exception('APK файл не найден для установки.');
    }

    final result = await OpenFilex.open(
      apkFile.path,
      type: 'application/vnd.android.package-archive',
    );

    if (result.type != ResultType.done) {
      throw Exception('Не удалось открыть установщик: ${result.message}');
    }

    final completed = localDataSource.readState().copyWith(
      status: UpdateTaskStatus.completed,
      failureReason: null,
    );
    await _emitState(completed);
  }

  @override
  Future<void> clear() async {
    _pollTimer?.cancel();
    await notificationService.clear();
    await localDataSource.clearState();
    _controller.add(UpdateTaskState.idle());
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      try {
        final state = localDataSource.readState();
        final id = state.downloaderTaskId;
        if (id == null) {
          _pollTimer?.cancel();
          return;
        }

        final tasks = await backgroundDataSource.loadTasks();
        final task = tasks.where((t) => t.taskId == id).firstOrNull;
        if (task == null) {
          return;
        }

        final mapped = await _mapTaskToState(state, task);
        await _emitState(mapped);

        if (mapped.status == UpdateTaskStatus.completed) {
          _pollTimer?.cancel();
          await finalizeDownloadAndExtract();
        }

        if (mapped.status == UpdateTaskStatus.failed ||
            mapped.status == UpdateTaskStatus.interrupted ||
            mapped.status == UpdateTaskStatus.readyToInstall) {
          _pollTimer?.cancel();
        }
      } catch (e, st) {
        talker.handle(e, st, '[UpdateTaskRepository] polling failed');
      }
    });
  }

  Future<UpdateTaskState> _mapTaskToState(
    UpdateTaskState current,
    DownloadTask task,
  ) async {
    final progress = (task.progress / 100).clamp(0, 1).toDouble();

    switch (task.status) {
      case DownloadTaskStatus.enqueued:
      case DownloadTaskStatus.running:
        return current.copyWith(
          status: UpdateTaskStatus.downloading,
          progress: progress,
          zipPath: '${task.savedDir}/${task.filename}',
          failureReason: null,
        );
      case DownloadTaskStatus.complete:
        return current.copyWith(
          status: UpdateTaskStatus.completed,
          progress: 1,
          zipPath: '${task.savedDir}/${task.filename}',
        );
      case DownloadTaskStatus.failed:
      case DownloadTaskStatus.canceled:
        final resumed = await backgroundDataSource.resumeTask(task.taskId) ??
            await backgroundDataSource.retryTask(task.taskId);
        if (resumed != null) {
          return current.copyWith(
            status: UpdateTaskStatus.downloading,
            downloaderTaskId: resumed,
            failureReason: null,
          );
        }

        return current.copyWith(
          status: UpdateTaskStatus.interrupted,
          failureReason: 'Скачивание прервано. Нажмите обновить снова.',
        );
      case DownloadTaskStatus.paused:
        return current.copyWith(
          status: UpdateTaskStatus.interrupted,
          failureReason: 'Скачивание приостановлено.',
        );
      case DownloadTaskStatus.undefined:
        return current.copyWith(
          status: UpdateTaskStatus.failed,
          failureReason: 'Неизвестный статус загрузки',
        );
    }
  }

  Future<void> _emitState(UpdateTaskState state) async {
    await localDataSource.saveState(state);
    talker.info('[UpdateTaskRepository] state persisted: ${state.status.name}, progress=${(state.progress * 100).toStringAsFixed(0)}%');
    await notificationService.showState(state);
    _controller.add(state);
  }

  bool _isActive(UpdateTaskStatus status) {
    return status == UpdateTaskStatus.queued ||
        status == UpdateTaskStatus.downloading ||
        status == UpdateTaskStatus.extracting ||
        status == UpdateTaskStatus.installing;
  }
}
