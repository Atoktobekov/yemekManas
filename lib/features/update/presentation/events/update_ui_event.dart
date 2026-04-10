import 'dart:io';

import 'package:ManasYemek/features/update/domain/entities/update_info_entity.dart';

sealed class UpdateUiEvent {}

class ShowUpdateDialog extends UpdateUiEvent {
  final UpdateInfoEntity updateInfo;

  ShowUpdateDialog(this.updateInfo);
}

class ShowPermissionExplanation extends UpdateUiEvent {
  final String url;
  final String latestVersion;

  ShowPermissionExplanation(this.url, this.latestVersion);
}

class ShowInstallDialog extends UpdateUiEvent {
  final File apkFile;

  ShowInstallDialog(this.apkFile);
}

class ShowOpenSettingsDialog extends UpdateUiEvent {}

class ShowSnackbar extends UpdateUiEvent {
  final String message;

  ShowSnackbar(this.message);
}
