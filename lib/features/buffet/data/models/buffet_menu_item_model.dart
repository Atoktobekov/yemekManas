import 'package:ManasYemek/features/buffet/domain/entities/buffet_menu_item_entity.dart';

class BuffetMenuItemModel {
  final String id;
  final String name;
  final double price;
  final String photoUrl;

  const BuffetMenuItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.photoUrl,
  });

  factory BuffetMenuItemModel.fromJson(Map<String, dynamic> json) {
    return BuffetMenuItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      photoUrl: json['photoUrl'] as String,
    );
  }

  BuffetMenuItemEntity toEntity() {
    return BuffetMenuItemEntity(
      id: id,
      name: name,
      price: price,
      photoUrl: photoUrl,
    );
  }
}
