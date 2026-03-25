import 'package:ManasYemek/core/error/failures.dart';
import 'package:ManasYemek/features/dish/domain/repositories/dish_repository.dart';
import 'package:dartz/dartz.dart';

class RateDish {
  final DishRepository repository;

  RateDish(this.repository);

  Future<Either<Failure, double>> call({
    required String dishId,
    required double selectedRating,
  }) {
    return repository.rateDish(dishId: dishId, selectedRating: selectedRating);
  }
}
