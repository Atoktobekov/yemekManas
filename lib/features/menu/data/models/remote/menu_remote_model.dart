import 'package:ManasYemek/features/menu/domain/entities/daily_menu_entity.dart';
import 'package:ManasYemek/features/menu/domain/entities/menu_item_entity.dart';

class MenuRemoteModel {
  final String date;
  final List<String> itemIds;

  const MenuRemoteModel({
    required this.date,
    required this.itemIds,
  });

  factory MenuRemoteModel.fromJson(Map<String, dynamic> json) {
    return MenuRemoteModel(
      date: json['date']?.toString() ?? '',
      itemIds: (json['items'] as List? ?? []).map((e) => e.toString()).toList(),
    );
  }

  DailyMenuEntity toEntity(
      Map<String, MenuItemEntity> foodMap,
      ) {
    return DailyMenuEntity(
      date: date,
      items: itemIds.map((id) => foodMap[id]).whereType<MenuItemEntity>().toList(),
      lastUpdate: DateTime.now(),
    );
  }
}