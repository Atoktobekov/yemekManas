import 'dart:io';

import 'package:ManasYemek/features/update/domain/repositories/update_task_repository.dart';

class InstallDownloadedUpdateUseCase {
  final UpdateTaskRepository repository;

  InstallDownloadedUpdateUseCase(this.repository);

  Future<void> call(File apkFile) async {
    await repository.markInstalling();
    await repository.installApk(apkFile);
  }
}
