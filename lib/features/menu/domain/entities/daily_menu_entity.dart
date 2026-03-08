import 'package:ManasYemek/features/menu/domain/entities/menu_item_entity.dart';

class DailyMenuEntity {
  final String date;
  final List<MenuItemEntity> items;
  final DateTime lastUpdate;

  const DailyMenuEntity({
    required this.date,
    required this.items,
    required this.lastUpdate,
  });

  int get totalCalories => items.fold(0, (sum, item) => sum + item.calories);
}