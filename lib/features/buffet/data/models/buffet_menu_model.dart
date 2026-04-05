import 'package:ManasYemek/features/buffet/data/models/buffet_category_model.dart';
import 'package:ManasYemek/features/buffet/domain/entities/buffet_menu_entity.dart';

class BuffetMenuModel extends BuffetMenuEntity {
  const BuffetMenuModel({
    required super.categories,
    required super.currency,
    required super.lastUpdated,
  });

  factory BuffetMenuModel.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] as Map<String, dynamic>;
    return BuffetMenuModel(
      categories: (json['categories'] as List)
          .map((e) => BuffetCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currency: meta['currency'] as String,
      lastUpdated: meta['lastUpdated'] as String,
    );
  }
}