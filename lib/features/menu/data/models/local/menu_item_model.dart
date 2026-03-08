import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:ManasYemek/features/menu/domain/entities/menu_item_entity.dart';

part 'menu_item_model.g.dart';

@HiveType(typeId: 1)
class MenuItemModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int calories;

  @HiveField(3)
  final String thumbUrl;

  @HiveField(4)
  final String fullPhotoUrl;

  MenuItemModel({
    required this.id,
    required this.name,
    required this.calories,
    required this.thumbUrl,
    required this.fullPhotoUrl,
  });

  factory MenuItemModel.fromEntity(MenuItemEntity entity) {
    return MenuItemModel(
      id: entity.id,
      name: entity.name,
      calories: entity.calories,
      thumbUrl: entity.thumbUrl,
      fullPhotoUrl: entity.fullPhotoUrl,
    );
  }

  MenuItemEntity toEntity() {
    return MenuItemEntity(
      id: id,
      name: name,
      calories: calories,
      thumbUrl: thumbUrl,
      fullPhotoUrl: fullPhotoUrl,
    );
  }
}