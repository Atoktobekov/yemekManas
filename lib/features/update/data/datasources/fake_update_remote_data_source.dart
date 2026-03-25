// test/fakes/fake_update_remote_data_source.dart

import 'package:ManasYemek/features/update/data/datasources/update_remote_data_source.dart';
import 'package:ManasYemek/features/update/data/models/update_info_model.dart';

class FakeUpdateRemoteDataSource implements UpdateRemoteDataSource {
  final UpdateInfoModel? modelToReturn;
  final String currentVersion;
  final Exception? exceptionToThrow;

  const FakeUpdateRemoteDataSource({
    this.modelToReturn,
    this.currentVersion = '1.0.0',
    this.exceptionToThrow,
  });

  @override
  Future<(UpdateInfoModel, String)?> fetchUpdateInfo() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    if (modelToReturn == null) return null;
    return (modelToReturn!, currentVersion);
  }
}