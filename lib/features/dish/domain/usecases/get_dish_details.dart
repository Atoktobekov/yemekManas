import 'package:ManasYemek/core/error/failures.dart';
import 'package:ManasYemek/features/dish/domain/entities/dish_details_entity.dart';
import 'package:ManasYemek/features/dish/domain/repositories/dish_repository.dart';
import 'package:dartz/dartz.dart';

class GetDishDetails {
  final DishRepository repository;

  GetDishDetails(this.repository);

  Future<Either<Failure, DishDetailsEntity>> call(String dishId) {
    return repository.getDishDetails(dishId);
  }
}
