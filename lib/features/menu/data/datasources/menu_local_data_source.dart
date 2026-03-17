import 'package:ManasYemek/features/menu/data/models/local/daily_menu_model.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'package:ManasYemek/features/menu/domain/entities/daily_menu_entity.dart';

class MenuLocalDataSource {
  final Box<DailyMenuModel> _box;

  const MenuLocalDataSource(this._box);

  Future<void> saveMenus(List<DailyMenuEntity> menus) async {
    final models = menus.map(DailyMenuModel.fromEntity).toList();

    final menuMap = {
      for (final item in models) item.date: item,
    };

    await _box.putAll(menuMap);
  }

  List<DailyMenuEntity> getCachedMenus() {
    return _box.values.map((e) => e.toEntity()).toList();
  }
}
