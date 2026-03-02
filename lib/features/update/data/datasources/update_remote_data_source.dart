import 'package:ManasYemek/features/update/data/models/update_info_model.dart';

abstract class UpdateRemoteDataSource {
  Future<(UpdateInfoModel, String /* currentVersion */)?> fetchUpdateInfo();
}