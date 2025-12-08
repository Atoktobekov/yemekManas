import 'package:hive_ce_flutter/hive_flutter.dart';

import 'menu_item.dart';

part 'daily_menu.g.dart';

@HiveType(typeId: 2)
class DailyMenu {
  @HiveField(0)
  final String date;

  @HiveField(1)
  final List<MenuItem> items;

  @HiveField(2)
  final DateTime lastUpdate;

  DailyMenu({
    required this.date,
    required this.items,
    required this.lastUpdate
  });

  int get totalCalories => items.fold(0, (sum, item) => sum + item.caloriesCount);

  factory DailyMenu.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return DailyMenu(date: '', items: [], lastUpdate: DateTime.now());
    }

    final date = json['at']?.toString() ?? '';

    final itemsJson = json['items'] as List? ?? [];
    final itemsList = itemsJson
        .map((e) => MenuItem.fromJson(e as Map<String, dynamic>?))
        .toList();

    return DailyMenu(date: date, items: itemsList, lastUpdate: DateTime.now());
  }
}
