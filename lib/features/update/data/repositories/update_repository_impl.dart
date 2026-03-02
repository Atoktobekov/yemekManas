import 'package:ManasYemek/features/update/data/datasources/update_remote_data_source.dart';

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
  Future<UpdateInfoEntity?> checkForUpdate() async {
    final result = await remoteDataSource.fetchUpdateInfo();
    if (result == null) return null;

    final (model, currentVersion) = result;

    final isNewer =
    versionComparator.isNewer(model.latestVersion, currentVersion);

    if (!isNewer) return null;

    return UpdateInfoEntity(
      latestVersion: model.latestVersion,
      isForceUpdate: model.isForceUpdate,
      updateUrl: model.updateUrl,
      changelog: model.changelog,
    );
  }
}