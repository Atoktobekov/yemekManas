import 'package:ManasYemek/features/buffet/data/datasources/buffet_remote_datasource.dart';
import 'package:ManasYemek/features/buffet/data/repositories/buffet_repository_impl.dart';
import 'package:ManasYemek/features/buffet/domain/repositories/buffet_repository.dart';
import 'package:ManasYemek/features/buffet/domain/usecases/get_buffet_menu_usecase.dart';
import 'package:ManasYemek/features/buffet/presentation/providers/buffet_provider.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

void registerBuffetModule(GetIt getIt) {
  getIt.registerLazySingleton<BuffetRemoteDataSource>(
    () => BuffetRemoteDataSource(getIt<Dio>()),
  );

  getIt.registerLazySingleton<BuffetRepository>(
    () => BuffetRepositoryImpl(getIt<BuffetRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetBuffetMenuUseCase>(
    () => GetBuffetMenuUseCase(getIt<BuffetRepository>()),
  );

  getIt.registerFactory<BuffetProvider>(() => BuffetProvider(getIt<GetBuffetMenuUseCase>()));
}
