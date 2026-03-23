import 'package:ManasYemek/core/error/failures.dart';
import 'package:ManasYemek/features/dish/domain/repositories/dish_repository.dart';
import 'package:dartz/dartz.dart';

class AddComment {
  final DishRepository repository;

  AddComment(this.repository);

  Future<Either<Failure, void>> call({
    required String dishId,
    required String text,
  }) {
    return repository.addComment(dishId: dishId, text: text);
  }
}
