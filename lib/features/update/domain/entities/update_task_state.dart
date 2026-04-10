import 'dart:convert';

enum UpdateTaskStatus {
  idle,
  queued,
  downloading,
  interrupted,
  extracting,
  readyToInstall,
  installing,
  completed,
  failed,
}

class UpdateTaskState {
  final UpdateTaskStatus status;
  final String? targetVersion;
  final String? downloadUrl;
  final String? downloaderTaskId;
  final String? zipPath;
  final String? apkPath;
  final double progress;
  final String? failureReason;
  final DateTime updatedAt;

  const UpdateTaskState({
    required this.status,
    required this.updatedAt,
    this.targetVersion,
    this.downloadUrl,
    this.downloaderTaskId,
    this.zipPath,
    this.apkPath,
    this.progress = 0,
    this.failureReason,
  });

  factory UpdateTaskState.idle() => UpdateTaskState(
    status: UpdateTaskStatus.idle,
    updatedAt: DateTime.now(),
  );

  UpdateTaskState copyWith({
    UpdateTaskStatus? status,
    String? targetVersion,
    String? downloadUrl,
    String? downloaderTaskId,
    String? zipPath,
    String? apkPath,
    double? progress,
    String? failureReason,
    DateTime? updatedAt,
  }) {
    return UpdateTaskState(
      status: status ?? this.status,
      targetVersion: targetVersion ?? this.targetVersion,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      downloaderTaskId: downloaderTaskId ?? this.downloaderTaskId,
      zipPath: zipPath ?? this.zipPath,
      apkPath: apkPath ?? this.apkPath,
      progress: progress ?? this.progress,
      failureReason: failureReason,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status.name,
      'targetVersion': targetVersion,
      'downloadUrl': downloadUrl,
      'downloaderTaskId': downloaderTaskId,
      'zipPath': zipPath,
      'apkPath': apkPath,
      'progress': progress,
      'failureReason': failureReason,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UpdateTaskState.fromMap(Map<String, dynamic> map) {
    final statusName = map['status'] as String?;
    final parsedStatus = UpdateTaskStatus.values.firstWhere(
      (value) => value.name == statusName,
      orElse: () => UpdateTaskStatus.idle,
    );

    return UpdateTaskState(
      status: parsedStatus,
      targetVersion: map['targetVersion'] as String?,
      downloadUrl: map['downloadUrl'] as String?,
      downloaderTaskId: map['downloaderTaskId'] as String?,
      zipPath: map['zipPath'] as String?,
      apkPath: map['apkPath'] as String?,
      progress: (map['progress'] as num?)?.toDouble() ?? 0,
      failureReason: map['failureReason'] as String?,
      updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory UpdateTaskState.fromJson(String source) {
    return UpdateTaskState.fromMap(jsonDecode(source) as Map<String, dynamic>);
  }
}
