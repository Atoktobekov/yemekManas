import 'dart:async';
import 'package:ManasYemek/app.dart';
import 'package:ManasYemek/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

Future<void> main() async {

  final talker = TalkerFlutter.init();

  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await setupDependencies();

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
