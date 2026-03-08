import 'package:ManasYemek/features/update/data/datasources/update_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:ManasYemek/core/error/failure_mapper.dart';
import 'package:ManasYemek/core/error/failures.dart';
import 'package:ManasYemek/features/update/domain/entities/update_info_entity.dart';
import 'package:ManasYemek/features/update/domain/repositories/update_repository.dart';
import 'package:ManasYemek/features/update/domain/services/version_comparator.dart';

class UpdateRepositoryImpl implements UpdateRepository {
  final UpdateRemoteDataSource remoteDataSource;
  final VersionComparator versionComparator;

  UpdateRepositoryImpl({
    required this.remoteDataSource,
    required this.versionComparator,
  });

  @override
  Future<Either<Failure, UpdateInfoEntity?>> checkForUpdate() async {
    try {
      final result = await remoteDataSource.fetchUpdateInfo();
      if (result == null) return const Right(null);

      final (model, currentVersion) = result;

      final isNewer = versionComparator.isNewer(
        model.latestVersion,
        currentVersion,
      );

      if (!isNewer) return const Right(null);

      return Right(
        UpdateInfoEntity(
          latestVersion: model.latestVersion,
          isForceUpdate: model.isForceUpdate,
          updateUrl: model.updateUrl,
          changelog: model.changelog,
        ),
      );
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}