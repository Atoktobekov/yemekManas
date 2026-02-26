import 'package:ManasYemek/features/menu/domain/entities/daily_menu_entity.dart';
import 'package:ManasYemek/features/menu/domain/entities/menu_item_entity.dart';

class MenuResponseModel {
  final List<MenuItemEntity> foods;
  final List<DailyMenuEntity> menus;

  const MenuResponseModel({required this.foods, required this.menus});

  factory MenuResponseModel.fromJson(Map<String, dynamic> json, {String locale = 'tr'}) {
    final foodsJson = (json['foods'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();

    final foods = foodsJson.map((foodJson) {
      final nameMap = (foodJson['name'] as Map?)?.cast<String, dynamic>() ?? const {};
      return MenuItemEntity(
        id: foodJson['id']?.toString() ?? '',
        name: (nameMap[locale] ?? nameMap['en'] ?? nameMap['tr'] ?? '').toString(),
        calories: (foodJson['calories'] as num?)?.toInt() ?? 0,
        thumbUrl: foodJson['thumbUrl']?.toString() ?? '',
        fullPhotoUrl: foodJson['fullPhotoUrl']?.toString() ?? '',
      );
    }).toList();

    final foodMap = {for (final item in foods) item.id: item};

    final menusJson = (json['menus'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();

    final now = DateTime.now();
    final menus = menusJson.map((menuJson) {
      final itemIds = (menuJson['items'] as List? ?? const []).map((e) => e.toString());
      final mappedItems = itemIds.map((id) => foodMap[id]).whereType<MenuItemEntity>().toList();

      return DailyMenuEntity(
        date: menuJson['date']?.toString() ?? '',
        items: mappedItems,
        lastUpdate: now,
      );
    }).toList();

    return MenuResponseModel(foods: foods, menus: menus);
  }
}
