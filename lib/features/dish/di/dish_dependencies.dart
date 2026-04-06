import 'package:ManasYemek/features/dish/data/datasources/dish_remote_data_source.dart';
import 'package:ManasYemek/features/dish/data/repositories/dish_repository_impl.dart';
import 'package:ManasYemek/features/dish/domain/repositories/dish_repository.dart';
import 'package:ManasYemek/features/dish/domain/usecases/add_comment.dart';
import 'package:ManasYemek/features/dish/domain/usecases/get_comments.dart';
import 'package:ManasYemek/features/dish/domain/usecases/get_dish_details.dart';
import 'package:ManasYemek/features/dish/domain/usecases/rate_dish.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

void setupDishDependencies(GetIt getIt) {
  getIt.registerLazySingleton<DishRemoteDataSource>(
    () => DishRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
  );

  getIt.registerLazySingleton<DishRepository>(
    () => DishRepositoryImpl(getIt<DishRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetDishDetails>(
    () => GetDishDetails(getIt<DishRepository>()),
  );

  getIt.registerLazySingleton<GetComments>(
    () => GetComments(getIt<DishRepository>()),
  );

  getIt.registerLazySingleton<AddComment>(
    () => AddComment(getIt<DishRepository>()),
  );

  getIt.registerLazySingleton<RateDish>(
    () => RateDish(getIt<DishRepository>()),
  );
}
