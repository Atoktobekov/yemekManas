import 'dart:io';

import 'package:ManasYemek/features/update/domain/entities/update_task_state.dart';

abstract class UpdateTaskRepository {
  Future<UpdateTaskState> getSavedState();

  Stream<UpdateTaskState> watchTask();

  Future<UpdateTaskState> startUpdate({
    required String url,
    required String targetVersion,
  });

  Future<UpdateTaskState> recover();

  Future<UpdateTaskState> finalizeDownloadAndExtract();

  Future<UpdateTaskState> markInstalling();

  Future<void> clear();

  Future<void> installApk(File apkFile);
}
