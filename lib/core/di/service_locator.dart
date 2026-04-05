import 'package:ManasYemek/core/constants/api_constants.dart';
import 'package:ManasYemek/core/di/modules/buffet_module.dart';
import 'package:ManasYemek/core/di/modules/dish_module.dart';
import 'package:ManasYemek/core/di/modules/menu_module.dart';
import 'package:ManasYemek/core/di/modules/update_module.dart';
import 'package:ManasYemek/core/logging/analytics_talker_observer.dart';
import 'package:ManasYemek/core/network/network_info.dart';
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

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
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

  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.menuBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  dio.interceptors.add(
    TalkerDioLogger(
      settings: const TalkerDioLoggerSettings(printResponseData: false),
      talker: talker,
    ),
  );

  getIt.registerSingleton<Dio>(dio);
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

  await registerMenuModule(getIt);
  registerDishModule(getIt);
  registerUpdateModule(getIt);
  registerBuffetModule(getIt);
}
