import 'package:ManasYemek/features/buffet/data/models/buffet_menu_item_model.dart';
import 'package:ManasYemek/features/buffet/domain/entities/buffet_category_entity.dart';

class BuffetCategoryModel {
  final String id;
  final String title;
  final List<BuffetMenuItemModel> items;

  const BuffetCategoryModel({
    required this.id,
    required this.title,
    required this.items,
  });

  factory BuffetCategoryModel.fromJson(Map<String, dynamic> json) {
    return BuffetCategoryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      items: (json['items'] as List)
          .map((e) => BuffetMenuItemModel.fromJson(e as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  BuffetCategoryEntity toEntity() {
    return BuffetCategoryEntity(
      id: id,
      title: title,
      items: items.map((item) => item.toEntity()).toList(growable: false),
    );
  }
}
