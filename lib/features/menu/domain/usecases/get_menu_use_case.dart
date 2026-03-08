import 'package:ManasYemek/core/error/failures.dart';
import 'package:ManasYemek/features/menu/domain/entities/daily_menu_entity.dart';
import 'package:ManasYemek/features/menu/domain/repositories/menu_repository.dart';
import 'package:dartz/dartz.dart';

class GetMenuUseCase {
  final MenuRepository _menuRepository;

  const GetMenuUseCase(this._menuRepository);

  Future<Either<Failure, List<DailyMenuEntity>>> call() {
    return _menuRepository.getMenus();
  }
}
