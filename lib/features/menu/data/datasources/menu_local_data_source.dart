import 'package:hive_ce_flutter/hive_flutter.dart';

import 'package:ManasYemek/features/menu/domain/entities/daily_menu_entity.dart';

class MenuLocalDataSource {
  final Box<DailyMenuEntity> _box;

  const MenuLocalDataSource(this._box);

  Future<void> saveMenus(List<DailyMenuEntity> menus) async {
    final menuMap = {for (final item in menus) item.date: item};
    await _box.putAll(menuMap);
  }

  List<DailyMenuEntity> getCachedMenus() => _box.values.toList();
}
