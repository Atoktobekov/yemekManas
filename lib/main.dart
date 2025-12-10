import 'dart:async';

import 'package:ManasYemek/app.dart';
import 'package:ManasYemek/models/daily_menu.dart';
import 'package:ManasYemek/models/menu_item.dart';
import 'package:ManasYemek/repositories/menu_repository.dart';
import 'package:ManasYemek/services/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

Future<void> main() async {
  final getIt = GetIt.instance;

  // Создаем Talker до runZonedGuarded, чтобы он был доступен всегда
  final talker = TalkerFlutter.init();

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // --- ИСПРАВЛЕНИЕ: РЕГИСТРИРУЕМ TALKER СРАЗУ ---
    getIt.registerSingleton(talker);

    FlutterError.onError =
        (details) => talker.handle(details.exception, details.stack);

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

    // Регистрируем остальные синглтоны
    getIt.registerSingleton(dio);
    getIt.registerSingleton(remoteConfig);

    const yemekBoxKey = "yemek_list_box";
    await Hive.initFlutter();
    Hive.registerAdapter(DailyMenuAdapter());
    Hive.registerAdapter(MenuItemAdapter());
    final yemekListBox = await Hive.openBox<DailyMenu>(yemekBoxKey);

    getIt.registerLazySingleton<MenuRepository>(
          () => MenuRepository(
        yemekListBox: yemekListBox,
        apiService: ApiService2(),
      ),
    );

    getIt.registerSingleton<ValueNotifier<double>>(
        ValueNotifier<double>(0.0),
        instanceName: "DownloadProgress");

    getIt.registerLazySingleton<DownloadAndUpdateApkService>(
            () => DownloadAndUpdateApkService(
          dio: getIt<Dio>(),
          talker: getIt<Talker>(),
        ));

    // --- ИСПРАВЛЕНИЕ: Передаем зависимости в CheckForUpdateService ---
    getIt.registerLazySingleton<CheckForUpdateService>(
            () => CheckForUpdateService());

    runApp(const YemekApp());
  }, (error, stacktrace) {
    // Теперь это будет работать, так как talker уже создан
    talker.handle(error, stacktrace);
  });
}