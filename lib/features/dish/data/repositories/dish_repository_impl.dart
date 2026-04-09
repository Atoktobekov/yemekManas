import 'package:ManasYemek/core/error/failures.dart';
import 'package:ManasYemek/features/dish/data/datasources/dish_remote_data_source.dart';
import 'package:ManasYemek/features/dish/domain/entities/comment_entity.dart';
import 'package:ManasYemek/features/dish/domain/entities/dish_details_entity.dart';
import 'package:ManasYemek/features/dish/domain/repositories/dish_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

class DishRepositoryImpl implements DishRepository {
  final DishRemoteDataSource _remoteDataSource;

  DishRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, DishDetailsEntity>> getDishDetails(String dishId) async {
    try {
      final detailsModel = await _remoteDataSource.getDishDetails(dishId);
      return Right(detailsModel.toEntity());
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Unable to load dish details'));
    } catch (_) {
      return const Left(ServerFailure('Unexpected error while loading dish'));
    }
  }

  @override
  Stream<List<CommentEntity>> watchComments(String dishId) {
    return _remoteDataSource.watchComments(dishId).map(
      (models) => models.map((model) => model.toEntity()).toList(growable: false),
    );
  }

  @override
  Future<Either<Failure, void>> addComment({
    required String dishId,
    required String text,
  }) async {
    try {
      await _remoteDataSource.addComment(dishId: dishId, text: text);
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Unable to send comment'));
    } catch (_) {
      return const Left(ServerFailure('Unexpected error while adding comment'));
    }
  }

  @override
  Future<Either<Failure, double>> rateDish({
    required String dishId,
    required double selectedRating,
  }) async {
    try {
      final newRating = await _remoteDataSource.rateDish(
        dishId: dishId,
        selectedRating: selectedRating,
      );
      return Right(newRating);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Unable to rate this dish'));
    } catch (_) {
      return const Left(ServerFailure('Unexpected error while rating dish'));
    }
  }
}
