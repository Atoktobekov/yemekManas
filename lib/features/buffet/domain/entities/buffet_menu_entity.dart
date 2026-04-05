import 'package:ManasYemek/features/buffet/domain/entities/buffet_category_entity.dart';

class BuffetMenuEntity {
  final List<BuffetCategoryEntity> categories;
  final String currency;
  final String lastUpdated;

  const BuffetMenuEntity({
    required this.categories,
    required this.currency,
    required this.lastUpdated,
  });
}