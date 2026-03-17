import 'package:ManasYemek/features/menu/domain/entities/menu_item_entity.dart';


class FoodRemoteModel {
  final String id;
  final Map<String, dynamic> name;
  final int calories;
  final String thumbUrl;
  final String fullPhotoUrl;

  const FoodRemoteModel({
    required this.id,
    required this.name,
    required this.calories,
    required this.thumbUrl,
    required this.fullPhotoUrl,
  });

  factory FoodRemoteModel.fromJson(Map<String, dynamic> json) {
    return FoodRemoteModel(
      id: json['id']?.toString() ?? '',
      name: (json['name'] as Map?)?.cast<String, dynamic>() ?? const {},
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      thumbUrl: json['thumbUrl']?.toString() ?? '',
      fullPhotoUrl: json['fullPhotoUrl']?.toString() ?? '',
    );
  }

  MenuItemEntity toEntity({String locale = 'tr'}) {
    return MenuItemEntity(
      id: id,
      name: (name[locale] ?? name['en'] ?? name['tr'] ?? '').toString(),
      calories: calories,
      thumbUrl: thumbUrl,
      fullPhotoUrl: fullPhotoUrl,
    );
  }
}