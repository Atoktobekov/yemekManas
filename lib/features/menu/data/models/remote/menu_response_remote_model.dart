import 'package:ManasYemek/features/menu/domain/entities/daily_menu_entity.dart';

import 'food_remote_model.dart';
import 'menu_remote_model.dart';

class MenuResponseRemoteModel {
  final List<FoodRemoteModel> foods;
  final List<MenuRemoteModel> menus;

  const MenuResponseRemoteModel({
    required this.foods,
    required this.menus,
  });

  factory MenuResponseRemoteModel.fromJson(Map<String, dynamic> json) {
    final foods = (json['foods'] as List? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(FoodRemoteModel.fromJson)
        .toList();

    final menus = (json['menus'] as List? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(MenuRemoteModel.fromJson)
        .toList();

    return MenuResponseRemoteModel(
      foods: foods,
      menus: menus,
    );
  }

  List<DailyMenuEntity> toEntities({required String locale}) {
    final foodEntities = foods
        .map((food) => food.toEntity(localeCode: locale))
        .toList();

    final foodMap = {
      for (final food in foodEntities) food.id: food,
    };

    return menus
        .map((menu) => menu.toEntity(foodMap))
        .toList();
  }
}
