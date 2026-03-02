import 'package:ManasYemek/features/update/domain/entities/update_info_entity.dart';
import 'package:ManasYemek/features/update/domain/repositories/update_repository.dart';

class CheckForUpdateUseCase {
  final UpdateRepository repository;

  CheckForUpdateUseCase(this.repository);

  Future<UpdateInfoEntity?> call() {
    return repository.checkForUpdate();
  }
}