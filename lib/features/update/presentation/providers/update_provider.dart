import 'dart:io';

import 'package:ManasYemek/core/error/exceptions.dart';
import 'package:ManasYemek/core/platform/download_and_update_service.dart';
import 'package:ManasYemek/features/update/domain/usecases/check_for_update_use_case.dart';
import 'package:ManasYemek/features/update/presentation/events/update_ui_event.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:talker_flutter/talker_flutter.dart';

class UpdateProvider extends ChangeNotifier {
  //final UpdateRepositoryImpl _updateRepository;
  final CheckForUpdateUseCase _checkForUpdateUseCase;
  final DownloadAndUpdateApkService _downloadService;
  final Talker _talker;

  final ValueNotifier<double> downloadProgress = ValueNotifier<double>(0.0);
  final ValueNotifier<UpdateUiEvent?> uiEvent = ValueNotifier(null);

  UpdateProvider({
    required CheckForUpdateUseCase checkForUpdateUseCase,
    required DownloadAndUpdateApkService downloadService,
    required Talker talker,
  }) : _checkForUpdateUseCase = checkForUpdateUseCase,
        _downloadService = downloadService,
        _talker = talker;

  factory UpdateProvider.fromGetIt() {
    final getIt = GetIt.instance;
    return UpdateProvider(
      checkForUpdateUseCase: getIt<CheckForUpdateUseCase>(),
      downloadService: getIt<DownloadAndUpdateApkService>(),
      talker: getIt<Talker>(),
    );
  }

  Future<void> checkForUpdate() async {
    try {
      final updateInfo = await _checkForUpdateUseCase();
      if (updateInfo != null) {
        uiEvent.value = ShowUpdateDialog(updateInfo);
      }
    } catch (e, st) {
      _talker.handle(e, st, '[UpdateProvider] failed to check updates');
    }
  }

  Future<void> requestPermissionAndStartDownload(String url) async {
    final status = await Permission.requestInstallPackages.status;
    if (status.isGranted) {
      await _startDownload(url);
    } else {
      uiEvent.value = ShowPermissionExplanation(url);
    }
  }

  Future<void> proceedWithPermissionRequest(String url) async {
    final status = await Permission.requestInstallPackages.request();

    if (status.isGranted) {
      await _startDownload(url);
    } else if (status.isPermanentlyDenied) {
      uiEvent.value = ShowOpenSettingsDialog();
    } else {
      uiEvent.value = ShowSnackbar('Need permission to continue.');
    }
  }

  Future<void> _startDownload(String url) async {
    try {
      final apkFile = await _downloadService.downloadAndPrepareUpdate(
        url,
        progressNotifier: downloadProgress,
      );

      if (apkFile != null) {
        uiEvent.value = ShowInstallDialog(apkFile);
      }
    } on ApkNotFoundException catch (e) {
      uiEvent.value = ShowSnackbar(e.message);
    } catch (e, st) {
      _talker.handle(e, st, '[UpdateProvider] error while downloading');
      uiEvent.value = ShowSnackbar('Update error: $e');
    }
  }

  Future<void> installApk(File apkFile) async {
    try {
      await _downloadService.installApk(apkFile);
    } catch (e, st) {
      _talker.handle(e, st, '[UpdateProvider] failed to install apk');
      uiEvent.value = ShowSnackbar('Failed to install: $e');
    }
  }

  @override
  void dispose() {
    downloadProgress.dispose();
    uiEvent.dispose();
    super.dispose();
  }
}
