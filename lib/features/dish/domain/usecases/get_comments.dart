import 'package:ManasYemek/features/dish/domain/entities/comment_entity.dart';
import 'package:ManasYemek/features/dish/domain/repositories/dish_repository.dart';

class GetComments {
  final DishRepository repository;

  GetComments(this.repository);

  Stream<List<CommentEntity>> call(String dishId) {
    return repository.watchComments(dishId);
  }
}
