import 'package:ManasYemek/features/menu/domain/entities/daily_menu_entity.dart';
import 'package:ManasYemek/features/menu/domain/repositories/menu_repository.dart';

class GetMenuUseCase {
  final MenuRepository _menuRepository;

  const GetMenuUseCase(this._menuRepository);

  Future<List<DailyMenuEntity>> call() => _menuRepository.getMenus();
}
