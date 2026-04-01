import 'package:ManasYemek/features/buffet/domain/entities/buffet_menu_item_entity.dart';

class BuffetMenuItemModel extends BuffetMenuItemEntity {
  const BuffetMenuItemModel({
    required super.id,
    required super.name,
    required super.price,
    required super.photoUrl,
  });

  factory BuffetMenuItemModel.fromJson(Map<String, dynamic> json) {
    return BuffetMenuItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      photoUrl: json['photoUrl'] as String,
    );
  }
}