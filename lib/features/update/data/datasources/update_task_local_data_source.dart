import 'package:ManasYemek/features/update/domain/entities/update_task_state.dart';
import 'package:hive_ce/hive.dart';

class UpdateTaskLocalDataSource {
  static const String _taskStateKey = 'update_task_state_v2';

  final Box<String> settingsBox;

  UpdateTaskLocalDataSource({required this.settingsBox});

  UpdateTaskState readState() {
    final raw = settingsBox.get(_taskStateKey);
    if (raw == null || raw.isEmpty) {
      return UpdateTaskState.idle();
    }

    try {
      return UpdateTaskState.fromJson(raw);
    } catch (_) {
      return UpdateTaskState.idle();
    }
  }

  Future<void> saveState(UpdateTaskState state) async {
    await settingsBox.put(_taskStateKey, state.toJson());
  }

  Future<void> clearState() async {
    await settingsBox.delete(_taskStateKey);
  }
}
