import 'package:ManasYemek/core/error/failures.dart';
import 'package:ManasYemek/features/buffet/domain/entities/buffet_menu_entity.dart';
import 'package:ManasYemek/features/buffet/domain/repositories/buffet_repository.dart';
import 'package:dartz/dartz.dart';

class GetBuffetMenuUseCase {
  final BuffetRepository _repository;

  const GetBuffetMenuUseCase(this._repository);

  Future<Either<Failure, BuffetMenuEntity>> call() => _repository.getMenu();
}
