import 'package:ManasYemek/core/config/cache_config.dart';
import 'package:ManasYemek/core/logging/analytics_talker_observer.dart';
import 'package:ManasYemek/core/platform/download_and_update_service.dart';
import 'package:ManasYemek/features/menu/data/models/local/daily_menu_model.dart';
import 'package:ManasYemek/features/menu/data/models/local/menu_item_model.dart';
import 'package:ManasYemek/features/update/data/datasources/update_remote_data_source.dart';
import 'package:ManasYemek/features/update/data/datasources/update_remote_data_source_impl.dart';
import 'package:ManasYemek/features/update/domain/repositories/update_repository.dart';
import 'package:ManasYemek/features/update/domain/services/version_comparator.dart';
import 'package:ManasYemek/features/update/domain/usecases/check_for_update_use_case.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:ManasYemek/core/constants/api_constants.dart';
import 'package:ManasYemek/core/network/network_info.dart';
import 'package:ManasYemek/features/menu/data/datasources/menu_local_data_source.dart';
import 'package:ManasYemek/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:ManasYemek/features/menu/data/repositories/menu_repository_impl.dart';
import 'package:ManasYemek/features/menu/domain/repositories/menu_repository.dart';
import 'package:ManasYemek/features/menu/domain/usecases/get_menu_use_case.dart';
import 'package:ManasYemek/features/update/data/repositories/update_repository_impl.dart';

import 'package:ManasYemek/firebase_options.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  /// Firebase setup for analytics
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// Analytics initialization
  final analytics = FirebaseAnalytics.instance;
  getIt.registerSingleton<FirebaseAnalytics>(analytics);
  getIt.registerSingleton<FirebaseAnalyticsObserver>(
    FirebaseAnalyticsObserver(analytics: analytics),
  );

  /// init talker with new Analytics observer
  final talker = TalkerFlutter.init(
    observer: AnalyticsTalkerObserver(analytics: analytics),
  );
  getIt.registerSingleton<Talker>(talker);

  /// setting up Dio
  final menuDio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.menuBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  menuDio.interceptors.add(
    TalkerDioLogger(
      settings: const TalkerDioLoggerSettings(printResponseData: false),
      talker: talker,
    ),
  );
  getIt.registerSingleton<Dio>(menuDio);
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfo());

  /// setting up Remote Config
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ),
  );
  await remoteConfig.setDefaults(const {
    'latest_version': '1.0.0',
    'update_required': false,
    'update_url': '',
    'update_changelog': 'Initial release.',
  });
  getIt.registerSingleton<FirebaseRemoteConfig>(remoteConfig);

  /// Database and repos setup
  await Hive.initFlutter();
  Hive.registerAdapter(DailyMenuModelAdapter());
  Hive.registerAdapter(MenuItemModelAdapter());

  final menuBox = await Hive.openBox<DailyMenuModel>('menu_list_box');

  getIt.registerLazySingleton<MenuRemoteDataSource>(
        () => MenuRemoteDataSource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<MenuLocalDataSource>(
        () => MenuLocalDataSource(menuBox),
  );

  getIt.registerLazySingleton<CacheConfig>(
        () => const CacheConfig(
      menuTTL: Duration(hours: 4),
    ),
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

  getIt.registerLazySingleton<GetMenuUseCase>(
        () => GetMenuUseCase(getIt<MenuRepository>()),
  );



  /// Update setup
  getIt.registerLazySingleton<DownloadAndUpdateApkService>(
        () => DownloadAndUpdateApkService(dio: getIt<Dio>(), talker: getIt<Talker>()),
  );

  getIt.registerLazySingleton<VersionComparator>(
        () => VersionComparator(),
  );

  getIt.registerLazySingleton<UpdateRemoteDataSource>(
        () => UpdateRemoteDataSourceImpl(
      remoteConfig: FirebaseRemoteConfig.instance,
      talker: getIt(),
    ),
  );

  getIt.registerLazySingleton<UpdateRepository>(
        () => UpdateRepositoryImpl(
      remoteDataSource: getIt(),
      versionComparator: getIt(),
    ),
  );

  getIt.registerLazySingleton(
        () => CheckForUpdateUseCase(getIt()),
  );
}