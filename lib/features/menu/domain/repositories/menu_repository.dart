import 'package:ManasYemek/core/error/failures.dart';
import 'package:ManasYemek/features/menu/domain/entities/daily_menu_entity.dart';
import 'package:dartz/dartz.dart';

abstract class MenuRepository {
  Future<Either<Failure, List<DailyMenuEntity>>> getMenus({required String localeCode});
  bool isDataFromCache();
}
