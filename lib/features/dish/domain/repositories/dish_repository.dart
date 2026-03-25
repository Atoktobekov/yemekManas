import 'package:ManasYemek/core/error/failures.dart';
import 'package:ManasYemek/features/dish/domain/entities/comment_entity.dart';
import 'package:ManasYemek/features/dish/domain/entities/dish_details_entity.dart';
import 'package:dartz/dartz.dart';

abstract class DishRepository {
  Future<Either<Failure, DishDetailsEntity>> getDishDetails(String dishId);

  Stream<List<CommentEntity>> watchComments(String dishId);

  Future<Either<Failure, void>> addComment({
    required String dishId,
    required String text,
  });

  Future<Either<Failure, double>> rateDish({
    required String dishId,
    required double selectedRating,
  });
}
