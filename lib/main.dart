import 'dart:async';

import 'package:ManasYemek/app.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() {
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

  runZonedGuarded(
    () => runApp(const YemekApp()),
    (error, stacktrace) => GetIt.instance<Talker>().handle(error, stacktrace),
  );
}
