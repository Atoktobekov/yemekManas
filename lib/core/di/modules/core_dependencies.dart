import 'package:ManasYemek/core/config/cache_config.dart';
import 'package:ManasYemek/core/constants/api_constants.dart';
import 'package:ManasYemek/core/logging/analytics_talker_observer.dart';
import 'package:ManasYemek/core/network/network_info.dart';
import 'package:ManasYemek/core/theme/theme_mode_controller.dart';
import 'package:ManasYemek/features/menu/data/models/local/daily_menu_model.dart';
import 'package:ManasYemek/features/menu/data/models/local/menu_item_model.dart';
import 'package:ManasYemek/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

Future<void> setupCoreDependencies(GetIt getIt) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final analytics = FirebaseAnalytics.instance;
  getIt.registerSingleton<FirebaseAnalytics>(analytics);
  getIt.registerSingleton<FirebaseAnalyticsObserver>(
    FirebaseAnalyticsObserver(analytics: analytics),
  );

  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

  final talker = TalkerFlutter.init(
    observer: AnalyticsTalkerObserver(analytics: analytics),
  );
  getIt.registerSingleton<Talker>(talker);

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

  await Hive.initFlutter();
  Hive.registerAdapter(DailyMenuModelAdapter());
  Hive.registerAdapter(MenuItemModelAdapter());

  final menuBox = await Hive.openBox<DailyMenuModel>('menu_list_box');
  final settingsBox = await Hive.openBox<String>('app_settings_box');

  getIt.registerSingleton<Box<DailyMenuModel>>(menuBox);
  getIt.registerSingleton<Box<String>>(settingsBox);

  getIt.registerLazySingleton<CacheConfig>(
    () => const CacheConfig(
      menuTTL: Duration(hours: 4),
    ),
  );

  final initialThemeMode =
      ThemeModeController.themeModeFromString(settingsBox.get(ThemeModeController.themeModeKey));
  getIt.registerSingleton<ThemeModeController>(
    ThemeModeController(
      settingsBox: settingsBox,
      initialThemeMode: initialThemeMode,
    ),
  );
}
