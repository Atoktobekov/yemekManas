import 'dart:io';

import 'package:ManasYemek/exceptions/exceptions.dart';
import 'package:ManasYemek/repositories/menu_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:ManasYemek/models/models.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:ManasYemek/services/services.dart';
import 'package:ManasYemek/view_models/ui_events/ui_events.dart';

enum MenuStatus { initial, loading, loaded, error }

class MenuViewModel extends ChangeNotifier {
  MenuStatus _status = MenuStatus.initial;

  MenuStatus get status => _status;

  List<DailyMenu> _menus = [];

  List<DailyMenu> get menus => _menus;

  String _message = '';

  String get message => _message;

  final repo = GetIt.instance<MenuRepository>();

  bool get isCached => repo.isDataFromCache();

  final _talker = GetIt.instance<Talker>();
  final _updateService = GetIt.instance<CheckForUpdateService>();
  final _downloadService = GetIt.instance<DownloadAndUpdateApkService>();

  final ValueNotifier<double> downloadProgress = ValueNotifier<double>(0.0);

  // Notifier to send events to UI
  final ValueNotifier<UiEvent?> uiEvent = ValueNotifier(null);

  Future<void> fetchMenu() async {
    _status = MenuStatus.loading;
    _message = '';
    notifyListeners();

    try {
      _menus = await repo.getMenuList();
      if(repo.isDataFromCache()){
        _message = 'No internet connection. Showing saved data.';
      }
      _status = MenuStatus.loaded;
    } on DataExpiredException {
      _message = 'No internet connection and saved data is too old.';
      _menus = [];
      _status = MenuStatus.error;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      _message = 'Failed downloading menu. Please try again later';
      _menus = [];
      _status = MenuStatus.error;
    } finally {
      notifyListeners();
    }
  }


  // app updating methods
  Future<void> checkForUpdate() async {
    try {
      final updateInfo = await _updateService.checkForUpdate();
      if (updateInfo != null) {
        uiEvent.value = ShowUpdateDialog(updateInfo);
      }
    } catch (e, st) {
      _talker.handle(e, st, "[ViewModel] Failed to check for update");
    }
  }

  Future<void> requestPermissionAndStartDownload(String url) async {
    var status = await Permission.requestInstallPackages.status;
    _talker.info("Initial install permission status: $status");

    if (status.isGranted) {
      await _startDownload(url);
    } else {
      uiEvent.value = ShowPermissionExplanation(url);
    }
  }

  Future<void> proceedWithPermissionRequest(String url) async {
    var status = await Permission.requestInstallPackages.request();
    _talker.info("Permission request result: $status");

    if (status.isGranted) {
      await _startDownload(url);
    } else if (status.isPermanentlyDenied) {
      uiEvent.value = ShowOpenSettingsDialog();
    } else {
      uiEvent.value = ShowSnackbar("Need permission to continue.");
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
      _talker.handle(e, null, "[ApkNotFoundException]");
      uiEvent.value = ShowSnackbar(e.message);
    } catch (e) {
      _talker.handle(e, null, "[Update Error]");
      uiEvent.value = ShowSnackbar("Update error: $e");
    }
  }

  Future<void> installApk(File apkFile) async {
    try {
      await _downloadService.installApk(apkFile);
    } catch (e) {
      _talker.handle(e, null, "[Install Error]");
      uiEvent.value = ShowSnackbar("Failed to install: $e");
    }
  }

  @override
  void dispose() {
    downloadProgress.dispose();
    uiEvent.dispose();
    super.dispose();
  }
}
