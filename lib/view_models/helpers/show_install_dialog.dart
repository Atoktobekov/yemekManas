import 'dart:io';
import 'ui_event.dart';

class ShowInstallDialog extends UiEvent {
  final File apkFile;
  ShowInstallDialog(this.apkFile);
}