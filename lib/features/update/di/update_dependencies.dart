import 'package:ManasYemek/features/update/data/datasources/fake_update_remote_data_source.dart';
import 'package:ManasYemek/features/update/data/datasources/update_background_data_source.dart';
import 'package:ManasYemek/features/update/data/datasources/update_remote_data_source.dart';
import 'package:ManasYemek/features/update/data/datasources/update_remote_data_source_impl.dart';
import 'package:ManasYemek/features/update/data/datasources/update_task_local_data_source.dart';
import 'package:ManasYemek/features/update/data/models/update_info_model.dart';
import 'package:ManasYemek/features/update/data/repositories/update_repository_impl.dart';
import 'package:ManasYemek/features/update/data/repositories/update_task_repository_impl.dart';
import 'package:ManasYemek/features/update/data/services/update_notification_service.dart';
import 'package:ManasYemek/features/update/domain/repositories/update_repository.dart';
import 'package:ManasYemek/features/update/domain/repositories/update_task_repository.dart';
import 'package:ManasYemek/features/update/domain/services/version_comparator.dart';
import 'package:ManasYemek/features/update/domain/usecases/check_for_update_use_case.dart';
import 'package:ManasYemek/features/update/domain/usecases/install_downloaded_update_use_case.dart';
import 'package:ManasYemek/features/update/domain/usecases/recover_update_task_use_case.dart';
import 'package:ManasYemek/features/update/domain/usecases/start_update_use_case.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:talker_flutter/talker_flutter.dart';

void setupUpdateDependencies(GetIt getIt) {
  getIt.registerLazySingleton(() => FlutterLocalNotificationsPlugin());
  getIt.registerLazySingleton(
    () => UpdateNotificationService(getIt<FlutterLocalNotificationsPlugin>()),
  );

  getIt.registerLazySingleton(
    () => UpdateTaskLocalDataSource(settingsBox: getIt<Box<String>>()),
  );
  getIt.registerLazySingleton(
    () => UpdateBackgroundDataSource(talker: getIt<Talker>()),
  );

  getIt.registerLazySingleton<UpdateTaskRepository>(
    () => UpdateTaskRepositoryImpl(
      localDataSource: getIt<UpdateTaskLocalDataSource>(),
      backgroundDataSource: getIt<UpdateBackgroundDataSource>(),
      notificationService: getIt<UpdateNotificationService>(),
      talker: getIt<Talker>(),
    ),
  );

  getIt.registerLazySingleton<VersionComparator>(() => VersionComparator());

  const useFakeUpdate = bool.fromEnvironment('USE_FAKE_UPDATE');

  getIt.registerLazySingleton<UpdateRemoteDataSource>(
    () => useFakeUpdate
        ? FakeUpdateRemoteDataSource(
            currentVersion: '1.0.0',
            modelToReturn: UpdateInfoModel(
              latestVersion: '1.2.0',
              isForceUpdate: false,
              updateUrl:
                  'https://www.dropbox.com/scl/fi/3qktucnpqrvopk45zl1fk/Yemekhane-2.0.0.zip?rlkey=7wahfwwduao9nlspxgdpy2bxd&st=buj85chb&dl=1',
              changelog:
                  '- Добавлено меню буфета!\n Можно наконец-то не стоять в ожидании у телевизора в кыраате\n '
                  '- Добавлена тёмная тема:\n Можно свободно переключать тему на светлую/темную\n - Улучшен дизайн приложения: '
                  '\n Пользоваться стало ещё удобнее',
            ),
          )
        : UpdateRemoteDataSourceImpl(
            remoteConfig: getIt<FirebaseRemoteConfig>(),
            talker: getIt<Talker>(),
          ),
  );

  getIt.registerLazySingleton<UpdateRepository>(
    () => UpdateRepositoryImpl(
      remoteDataSource: getIt(),
      versionComparator: getIt(),
    ),
  );

  getIt.registerLazySingleton(() => CheckForUpdateUseCase(getIt()));
  getIt.registerLazySingleton(() => StartUpdateUseCase(getIt()));
  getIt.registerLazySingleton(() => RecoverUpdateTaskUseCase(getIt()));
  getIt.registerLazySingleton(() => InstallDownloadedUpdateUseCase(getIt()));
}
