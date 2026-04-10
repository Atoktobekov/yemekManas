import 'dart:async';

import 'package:ManasYemek/app.dart';
import 'package:ManasYemek/core/di/service_locator.dart';
import 'package:ManasYemek/features/update/data/services/update_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

Future<void> main() async {
  final talker = TalkerFlutter.init();

  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize(debug: false, ignoreSsl: false);

    await setupDependencies();
    await GetIt.instance<UpdateNotificationService>().init();

    FlutterError.onError =
        (details) => GetIt.instance<Talker>().handle(details.exception, details.stack);

    runApp(const YemekApp());
  }, (error, stack) {
    if (GetIt.instance.isRegistered<Talker>()) {
      GetIt.instance<Talker>().handle(error, stack);
    } else {
      talker.handle(error, stack);
    }
  });
}
