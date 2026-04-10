import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ManasYemek/features/update/domain/entities/update_task_state.dart';
import 'package:ManasYemek/features/update/presentation/providers/update_provider.dart';

class UpdateDownloadProgress extends StatelessWidget {
  const UpdateDownloadProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<UpdateProvider>().taskState;

    if (state.status != UpdateTaskStatus.downloading &&
        state.status != UpdateTaskStatus.extracting &&
        state.status != UpdateTaskStatus.queued) {
      return const SizedBox.shrink();
    }

    final isDeterminate = state.status == UpdateTaskStatus.downloading;

    return SafeArea(
      top: false,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: Column(
          key: const ValueKey('update_progress_v2'),
          mainAxisSize: MainAxisSize.min,
          children: [
            LinearProgressIndicator(
              value: isDeterminate ? state.progress : null,
              minHeight: 4,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 7),
              child: Center(
                child: Text(
                  _buildText(state),
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _buildText(UpdateTaskState state) {
    switch (state.status) {
      case UpdateTaskStatus.queued:
        return 'Подготавливаем обновление...';
      case UpdateTaskStatus.extracting:
        return 'Распаковываем обновление...';
      case UpdateTaskStatus.downloading:
        return 'Скачиваем новую версию... ${(state.progress * 100).toStringAsFixed(0)}%';
      default:
        return '';
    }
  }
}
