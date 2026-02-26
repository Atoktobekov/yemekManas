import 'package:hive_ce_flutter/hive_flutter.dart';

import 'menu_item_entity.dart';

part 'daily_menu_entity.g.dart';

@HiveType(typeId: 2)
class DailyMenuEntity {
  @HiveField(0)
  final String date;

  @HiveField(1)
  final List<MenuItemEntity> items;

  @HiveField(2)
  final DateTime lastUpdate;

  const DailyMenuEntity({
    required this.date,
    required this.items,
    required this.lastUpdate,
  });

  int get totalCalories => items.fold(0, (sum, item) => sum + item.calories);
}
