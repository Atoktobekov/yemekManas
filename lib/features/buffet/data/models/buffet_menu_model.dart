import 'package:ManasYemek/features/buffet/data/models/buffet_category_model.dart';
import 'package:ManasYemek/features/buffet/domain/entities/buffet_menu_entity.dart';

class BuffetMenuModel {
  final List<BuffetCategoryModel> categories;
  final String currency;
  final String lastUpdated;

  const BuffetMenuModel({
    required this.categories,
    required this.currency,
    required this.lastUpdated,
  });

  factory BuffetMenuModel.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] as Map<String, dynamic>;
    return BuffetMenuModel(
      categories: (json['categories'] as List)
          .map((e) => BuffetCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(growable: false),
      currency: meta['currency'] as String,
      lastUpdated: meta['lastUpdated'] as String,
    );
  }

  BuffetMenuEntity toEntity() {
    return BuffetMenuEntity(
      categories: categories.map((category) => category.toEntity()).toList(growable: false),
      currency: currency,
      lastUpdated: lastUpdated,
    );
  }
}
