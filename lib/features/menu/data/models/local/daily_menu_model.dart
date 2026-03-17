import 'package:ManasYemek/features/menu/data/models/local/menu_item_model.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'package:ManasYemek/features/menu/domain/entities/daily_menu_entity.dart';

part 'daily_menu_model.g.dart';

@HiveType(typeId: 2)
class DailyMenuModel {
  @HiveField(0)
  final String date;

  @HiveField(1)
  final List<MenuItemModel> items;

  @HiveField(2)
  final DateTime lastUpdate;

   DailyMenuModel({
    required this.date,
    required this.items,
    required this.lastUpdate,
  });

  factory DailyMenuModel.fromEntity(DailyMenuEntity entity) {
    return DailyMenuModel(
      date: entity.date,
      items: entity.items.map(MenuItemModel.fromEntity).toList(),
      lastUpdate: entity.lastUpdate,
    );
  }

  DailyMenuEntity toEntity() {
    return DailyMenuEntity(
      date: date,
      items: items.map((e) => e.toEntity()).toList(),
      lastUpdate: lastUpdate,
    );
  }
}