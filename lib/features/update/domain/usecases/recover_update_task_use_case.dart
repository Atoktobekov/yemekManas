import 'package:ManasYemek/features/update/domain/entities/update_task_state.dart';
import 'package:ManasYemek/features/update/domain/repositories/update_task_repository.dart';

class RecoverUpdateTaskUseCase {
  final UpdateTaskRepository repository;

  RecoverUpdateTaskUseCase(this.repository);

  Future<UpdateTaskState> call() {
    return repository.recover();
  }
}
