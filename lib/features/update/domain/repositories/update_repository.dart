import 'package:ManasYemek/features/update/domain/entities/update_info_entity.dart';

abstract class UpdateRepository {
  Future<UpdateInfoEntity?> checkForUpdate();
}