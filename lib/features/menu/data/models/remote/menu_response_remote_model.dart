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

  List<DailyMenuEntity> toEntities({String locale = 'tr'}) {
    /// foods → entity
    final foodEntities = foods
        .map((food) => food.toEntity(locale: locale))
        .toList();

    /// fast lookup map
    final foodMap = {
      for (final food in foodEntities) food.id: food,
    };

    /// menus → entity
    return menus
        .map((menu) => menu.toEntity(foodMap))
        .toList();
  }
}