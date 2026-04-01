import 'package:ManasYemek/features/buffet/domain/entities/buffet_menu_entity.dart';

abstract interface class BuffetRepository {
  Future<BuffetMenuEntity> getMenu();
}