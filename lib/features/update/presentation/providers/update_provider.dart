import 'dart:async';
import 'dart:io';

import 'package:ManasYemek/features/update/domain/entities/update_task_state.dart';
import 'package:ManasYemek/features/update/domain/repositories/update_task_repository.dart';
import 'package:ManasYemek/features/update/domain/usecases/check_for_update_use_case.dart';
import 'package:ManasYemek/features/update/domain/usecases/install_downloaded_update_use_case.dart';
import 'package:ManasYemek/features/update/domain/usecases/recover_update_task_use_case.dart';
import 'package:ManasYemek/features/update/domain/usecases/start_update_use_case.dart';
import 'package:ManasYemek/features/update/presentation/events/update_ui_event.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:talker_flutter/talker_flutter.dart';

class UpdateProvider extends ChangeNotifier {
  final CheckForUpdateUseCase _checkForUpdateUseCase;
  final StartUpdateUseCase _startUpdateUseCase;
  final RecoverUpdateTaskUseCase _recoverUpdateTaskUseCase;
  final InstallDownloadedUpdateUseCase _installDownloadedUpdateUseCase;
  final UpdateTaskRepository _updateTaskRepository;
  final Talker _talker;

  final ValueNotifier<UpdateUiEvent?> uiEvent = ValueNotifier(null);

  StreamSubscription<UpdateTaskState>? _taskSubscription;
  UpdateTaskState _taskState = UpdateTaskState.idle();
  bool _restored = false;

  UpdateTaskState get taskState => _taskState;

  bool get isBusy =>
      _taskState.status == UpdateTaskStatus.downloading ||
      _taskState.status == UpdateTaskStatus.extracting ||
      _taskState.status == UpdateTaskStatus.queued ||
      _taskState.status == UpdateTaskStatus.installing;

  UpdateProvider({
    required CheckForUpdateUseCase checkForUpdateUseCase,
    required StartUpdateUseCase startUpdateUseCase,
    required RecoverUpdateTaskUseCase recoverUpdateTaskUseCase,
    required InstallDownloadedUpdateUseCase installDownloadedUpdateUseCase,
    required UpdateTaskRepository updateTaskRepository,
    required Talker talker,
  }) : _checkForUpdateUseCase = checkForUpdateUseCase,
       _startUpdateUseCase = startUpdateUseCase,
       _recoverUpdateTaskUseCase = recoverUpdateTaskUseCase,
       _installDownloadedUpdateUseCase = installDownloadedUpdateUseCase,
       _updateTaskRepository = updateTaskRepository,
       _talker = talker {
    _bindTaskWatcher();
  }

  factory UpdateProvider.fromGetIt() {
    final getIt = GetIt.instance;
    return UpdateProvider(
      checkForUpdateUseCase: getIt<CheckForUpdateUseCase>(),
      startUpdateUseCase: getIt<StartUpdateUseCase>(),
      recoverUpdateTaskUseCase: getIt<RecoverUpdateTaskUseCase>(),
      installDownloadedUpdateUseCase: getIt<InstallDownloadedUpdateUseCase>(),
      updateTaskRepository: getIt<UpdateTaskRepository>(),
      talker: getIt<Talker>(),
    );
  }

  Future<void> restoreTaskIfNeeded() async {
    if (_restored) return;
    _restored = true;

    try {
      _talker.info('[UpdateProvider] restoring update task state');
      _taskState = await _recoverUpdateTaskUseCase();
      _emitUiEventForState(_taskState);
      notifyListeners();
      _talker.info('[UpdateProvider] restore completed with status: ${_taskState.status.name}');
    } catch (e, st) {
      _talker.handle(e, st, '[UpdateProvider] failed to recover update task');
    }
  }

  Future<void> checkForUpdate() async {
    _talker.info('[UpdateProvider] checking for updates');
    final result = await _checkForUpdateUseCase();

    result.fold((failure) {
      _talker.error('[UpdateProvider] failed to check updates: ${failure.message}');
    }, (updateInfo) {
      if (updateInfo != null) {
        _talker.info('[UpdateProvider] update found: v${updateInfo.latestVersion}, force=${updateInfo.isForceUpdate}');
        uiEvent.value = ShowUpdateDialog(updateInfo);
      } else {
        _talker.info('[UpdateProvider] update not required');
      }
    });
  }

  Future<void> requestPermissionAndStartDownload({
    required String url,
    required String latestVersion,
  }) async {
    final status = await Permission.requestInstallPackages.status;
    _talker.info('[UpdateProvider] install unknown apps permission status: $status');
    if (status.isGranted) {
      await _startDownload(url: url, latestVersion: latestVersion);
    } else {
      uiEvent.value = ShowPermissionExplanation(url, latestVersion);
    }
  }

  Future<void> proceedWithPermissionRequest({
    required String url,
    required String latestVersion,
  }) async {
    final status = await Permission.requestInstallPackages.request();
    _talker.info('[UpdateProvider] install permission request result: $status');

    if (status.isGranted) {
      await _startDownload(url: url, latestVersion: latestVersion);
    } else if (status.isPermanentlyDenied) {
      uiEvent.value = ShowOpenSettingsDialog();
    } else {
      uiEvent.value = ShowSnackbar('Нужно разрешение для продолжения.');
    }
  }

  Future<void> _startDownload({
    required String url,
    required String latestVersion,
  }) async {
    try {
      await _requestNotificationPermissionIfNeeded();
      _talker.info('[UpdateProvider] starting update download for v$latestVersion');
      final state = await _startUpdateUseCase(
        url: url,
        targetVersion: latestVersion,
      );
      _taskState = state;
      notifyListeners();
      _talker.info('[UpdateProvider] download task started: ${state.downloaderTaskId}');
    } catch (e, st) {
      _talker.handle(e, st, '[UpdateProvider] error while starting update');
      uiEvent.value = ShowSnackbar('Ошибка обновления: $e');
    }
  }

  Future<void> _requestNotificationPermissionIfNeeded() async {
    if (!Platform.isAndroid) return;

    final status = await Permission.notification.status;
    _talker.info('[UpdateProvider] notification permission status: $status');

    if (status.isGranted) return;

    final requestResult = await Permission.notification.request();
    _talker.info('[UpdateProvider] notification permission request result: $requestResult');

    if (!requestResult.isGranted) {
      uiEvent.value = ShowSnackbar(
        'Без разрешения на уведомления статус обновления в шторке может не отображаться.',
      );
    }
  }

  Future<void> installApk(File apkFile) async {
    try {
      _talker.info('[UpdateProvider] launching installer: ${apkFile.path}');
      await _installDownloadedUpdateUseCase(apkFile);
      _talker.info('[UpdateProvider] installer launched successfully');
    } catch (e, st) {
      _talker.handle(e, st, '[UpdateProvider] failed to install apk');
      uiEvent.value = ShowSnackbar('Не удалось открыть установщик: $e');
    }
  }

  void _bindTaskWatcher() {
    _taskSubscription = _updateTaskRepository.watchTask().listen((state) {
      _talker.info(
        '[UpdateProvider] task state: ${state.status.name}, progress=${(state.progress * 100).toStringAsFixed(0)}%',
      );
      _taskState = state;
      _emitUiEventForState(state);
      notifyListeners();
    });
  }

  void _emitUiEventForState(UpdateTaskState state) {
    if (state.status == UpdateTaskStatus.readyToInstall && state.apkPath != null) {
      final apkFile = File(state.apkPath!);
      if (apkFile.existsSync()) {
        _talker.info('[UpdateProvider] apk ready to install: ${apkFile.path}');
        uiEvent.value = ShowInstallDialog(apkFile);
      }
      return;
    }

    if (state.status == UpdateTaskStatus.failed ||
        state.status == UpdateTaskStatus.interrupted) {
      if (state.failureReason != null && state.failureReason!.isNotEmpty) {
        _talker.warning('[UpdateProvider] task issue: ${state.failureReason}');
        uiEvent.value = ShowSnackbar(state.failureReason!);
      }
    }
  }

  @override
  void dispose() {
    _taskSubscription?.cancel();
    uiEvent.dispose();
    super.dispose();
  }
}
