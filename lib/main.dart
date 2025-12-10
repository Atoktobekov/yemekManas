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

Future<void> main() async {

  final getIt = GetIt.instance;

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    final dioOptions = BaseOptions(
      baseUrl: 'https://yemek-api.vercel.app/',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    );

    final talker = TalkerFlutter.init();
    final dio = Dio(dioOptions);

    dio.interceptors.add(
      TalkerDioLogger(
        settings: const TalkerDioLoggerSettings(printResponseData: false),
        talker: talker,
      ),
    );

    GetIt.instance.registerSingleton(talker);
    GetIt.instance.registerSingleton(dio);

    FlutterError.onError = (details) =>
        GetIt.instance<Talker>().handle(details.exception, details.stack);

    const yemekBoxKey = "yemek_list_box";
    await Hive.initFlutter();
    Hive.registerAdapter(DailyMenuAdapter());
    Hive.registerAdapter(MenuItemAdapter());
    final yemekListBox = await Hive.openBox<DailyMenu>(yemekBoxKey);

    GetIt.instance.registerLazySingleton<MenuRepository>(
          () => MenuRepository(
        yemekListBox: yemekListBox,
        apiService: ApiService2(),
      ),
    );

    GetIt.instance.registerSingleton<ValueNotifier<double>>
      (ValueNotifier<double>(0.0), instanceName: "DownloadProgress");

    GetIt.instance.registerLazySingleton<DownloadAndUpdateApkService>(() => DownloadAndUpdateApkService(
      dio: getIt<Dio>(),
      talker: getIt<Talker>(),
    ));

    GetIt.instance.registerLazySingleton<CheckForUpdateService>(() => CheckForUpdateService(
      dio: getIt<Dio>(),
      talker: getIt<Talker>(),
      progressNotifier: getIt<ValueNotifier<double>>(instanceName: "DownloadProgress"),
    ));

    runApp(const YemekApp());
  }, (error, stacktrace) {
    GetIt.instance<Talker>().handle(error, stacktrace);
  });
}
