import 'package:hive_ce_flutter/hive_flutter.dart';

part 'menu_item.g.dart';

@HiveType(typeId: 1)
class MenuItem {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int caloriesCount;

  @HiveField(2)
  final String photoUrl;

  MenuItem({
    required this.name,
    required this.caloriesCount,
    required this.photoUrl,
  });

  factory MenuItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return MenuItem(name: '', caloriesCount: 0, photoUrl: '');
    }

    final name = json['name']?.toString() ?? '';
    final caloriesCount = (json['calories_count'] is int)
        ? json['calories_count'] as int
        : int.tryParse(json['calories_count']?.toString() ?? '') ?? 0;
    final photoUrl = json['photo_url']?.toString() ?? '';

    return MenuItem(
      name: name,
      caloriesCount: caloriesCount,
      photoUrl: photoUrl,
    );
  }
}
