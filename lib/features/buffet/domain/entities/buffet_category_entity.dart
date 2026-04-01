import 'package:ManasYemek/features/buffet/domain/entities/buffet_menu_item_entity.dart';

class BuffetCategoryEntity {
  final String id;
  final String title;
  final List<BuffetMenuItemEntity> items;

  const BuffetCategoryEntity({
    required this.id,
    required this.title,
    required this.items,
  });
}