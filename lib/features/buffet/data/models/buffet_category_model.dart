import 'package:ManasYemek/features/buffet/data/models/buffet_menu_item_model.dart';
import 'package:ManasYemek/features/buffet/domain/entities/buffet_category_entity.dart';

class BuffetCategoryModel extends BuffetCategoryEntity {
  const BuffetCategoryModel({
    required super.id,
    required super.title,
    required super.items,
  });

  factory BuffetCategoryModel.fromJson(Map<String, dynamic> json) {
    return BuffetCategoryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      items: (json['items'] as List)
          .map((e) => BuffetMenuItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}