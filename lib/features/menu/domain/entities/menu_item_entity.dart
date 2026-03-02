import 'package:hive_ce_flutter/hive_flutter.dart';

part 'menu_item_entity.g.dart';

@HiveType(typeId: 1)
class MenuItemEntity {
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

  const MenuItemEntity({
    required this.id,
    required this.name,
    required this.calories,
    required this.thumbUrl,
    required this.fullPhotoUrl,
  });
}
