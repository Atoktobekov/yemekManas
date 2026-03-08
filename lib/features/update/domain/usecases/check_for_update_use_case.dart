import 'package:ManasYemek/core/error/failures.dart';
import 'package:ManasYemek/features/update/domain/entities/update_info_entity.dart';
import 'package:ManasYemek/features/update/domain/repositories/update_repository.dart';
import 'package:dartz/dartz.dart';

class CheckForUpdateUseCase {
  final UpdateRepository repository;

  CheckForUpdateUseCase(this.repository);

  Future<Either<Failure, UpdateInfoEntity?>> call() {
    return repository.checkForUpdate();
  }
}