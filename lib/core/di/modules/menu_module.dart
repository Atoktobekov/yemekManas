import 'package:ManasYemek/core/config/cache_config.dart';
import 'package:ManasYemek/core/network/network_info.dart';
import 'package:ManasYemek/features/menu/data/datasources/menu_local_data_source.dart';
import 'package:ManasYemek/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:ManasYemek/features/menu/data/repositories/menu_repository_impl.dart';
import 'package:ManasYemek/features/menu/domain/repositories/menu_repository.dart';
import 'package:ManasYemek/features/menu/domain/usecases/get_menu_use_case.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:ManasYemek/features/menu/data/models/local/daily_menu_model.dart';
import 'package:ManasYemek/features/menu/data/models/local/menu_item_model.dart';

Future<void> registerMenuModule(GetIt getIt) async {
  Hive.registerAdapter(DailyMenuModelAdapter());
  Hive.registerAdapter(MenuItemModelAdapter());

  final menuBox = await Hive.openBox<DailyMenuModel>('menu_list_box');

  getIt.registerLazySingleton<MenuRemoteDataSource>(() => MenuRemoteDataSource(getIt<Dio>()));
  getIt.registerLazySingleton<MenuLocalDataSource>(() => MenuLocalDataSource(menuBox));

  getIt.registerLazySingleton<CacheConfig>(
    () => const CacheConfig(menuTTL: Duration(hours: 4)),
  );

  getIt.registerLazySingleton<MenuRepository>(
    () => MenuRepositoryImpl(
      remoteDataSource: getIt<MenuRemoteDataSource>(),
      localDataSource: getIt<MenuLocalDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
      talker: getIt<Talker>(),
      cacheConfig: getIt<CacheConfig>(),
    ),
  );

  getIt.registerLazySingleton<GetMenuUseCase>(() => GetMenuUseCase(getIt<MenuRepository>()));
}
