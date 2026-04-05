import 'package:ManasYemek/core/error/failures.dart';
import 'package:ManasYemek/features/buffet/domain/entities/buffet_menu_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class BuffetRepository {
  Future<Either<Failure, BuffetMenuEntity>> getMenu();
}
