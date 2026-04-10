import 'package:ManasYemek/features/update/domain/entities/update_task_state.dart';
import 'package:ManasYemek/features/update/domain/repositories/update_task_repository.dart';

class StartUpdateUseCase {
  final UpdateTaskRepository repository;

  StartUpdateUseCase(this.repository);

  Future<UpdateTaskState> call({
    required String url,
    required String targetVersion,
  }) {
    return repository.startUpdate(url: url, targetVersion: targetVersion);
  }
}
