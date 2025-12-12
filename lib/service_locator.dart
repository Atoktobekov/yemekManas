import 'package:ManasYemek/models/daily_menu.dart';
import 'package:ManasYemek/models/menu_item.dart';
import 'package:ManasYemek/repositories/menu_repository.dart';
import 'package:ManasYemek/services/services.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'firebase_options.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // 1. packages
  final talker = TalkerFlutter.init();
  getIt.registerSingleton<Talker>(talker);

  final dioOptions = BaseOptions(
    baseUrl: 'https://yemek-api.vercel.app/',
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  );
  final dio = Dio(dioOptions);
  dio.interceptors.add(
    TalkerDioLogger(
      settings: const TalkerDioLoggerSettings(printResponseData: false),
      talker: talker,
    ),
  );
  getIt.registerSingleton<Dio>(dio);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));
  await remoteConfig.setDefaults(const {
    "latest_version": "1.0.0",
    "update_required": false,
    "update_url": "",
    "update_changelog": "Initial release.",
  });
  getIt.registerSingleton<FirebaseRemoteConfig>(remoteConfig);

  // 2. Hive local storage
  const yemekBoxKey = "yemek_list_box";
  await Hive.initFlutter();
  Hive.registerAdapter(DailyMenuAdapter());
  Hive.registerAdapter(MenuItemAdapter());
  final yemekListBox = await Hive.openBox<DailyMenu>(yemekBoxKey);

  // 3. repositories
  getIt.registerLazySingleton<MenuRepository>(
        () => MenuRepository(
      yemekListBox: yemekListBox,
      apiService: ApiService2(),
    ),
  );

  // 4. app services
  getIt.registerLazySingleton<DownloadAndUpdateApkService>(
        () => DownloadAndUpdateApkService(
      dio: getIt<Dio>(),
      talker: getIt<Talker>(),
    ),
  );

  getIt.registerLazySingleton<CheckForUpdateService>(
        () => CheckForUpdateService(),
  );

  // 5. UI dependencies
  getIt.registerSingleton<ValueNotifier<double>>(
      ValueNotifier<double>(0.0),
      instanceName: "DownloadProgress");
}
