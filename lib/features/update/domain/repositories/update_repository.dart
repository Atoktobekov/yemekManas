import 'package:ManasYemek/core/error/failures.dart';
import 'package:ManasYemek/features/update/domain/entities/update_info_entity.dart';
import 'package:dartz/dartz.dart';

abstract class UpdateRepository {
  Future<Either<Failure, UpdateInfoEntity?>> checkForUpdate();
}