import 'package:ManasYemek/features/menu/domain/entities/daily_menu_entity.dart';

abstract class MenuRepository {
  Future<List<DailyMenuEntity>> getMenus();
  bool isDataFromCache();
}
