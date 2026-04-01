import 'package:ManasYemek/features/buffet/domain/entities/buffet_menu_entity.dart';
import 'package:ManasYemek/features/buffet/domain/repositories/buffet_repository.dart';

class GetBuffetMenuUseCase {
  final BuffetRepository _repository;

  const GetBuffetMenuUseCase(this._repository);

  Future<BuffetMenuEntity> call() => _repository.getMenu();
}