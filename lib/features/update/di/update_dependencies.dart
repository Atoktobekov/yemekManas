import 'package:ManasYemek/core/platform/download_and_update_service.dart';
import 'package:ManasYemek/features/update/data/datasources/fake_update_remote_data_source.dart';
import 'package:ManasYemek/features/update/data/datasources/update_remote_data_source.dart';
import 'package:ManasYemek/features/update/data/datasources/update_remote_data_source_impl.dart';
import 'package:ManasYemek/features/update/data/models/update_info_model.dart';
import 'package:ManasYemek/features/update/data/repositories/update_repository_impl.dart';
import 'package:ManasYemek/features/update/domain/repositories/update_repository.dart';
import 'package:ManasYemek/features/update/domain/services/version_comparator.dart';
import 'package:ManasYemek/features/update/domain/usecases/check_for_update_use_case.dart';
import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

void setupUpdateDependencies(GetIt getIt) {
  getIt.registerLazySingleton<DownloadAndUpdateApkService>(
    () => DownloadAndUpdateApkService(dio: getIt<Dio>(), talker: getIt<Talker>()),
  );

  getIt.registerLazySingleton<VersionComparator>(
    () => VersionComparator(),
  );

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

  getIt.registerLazySingleton(
    () => CheckForUpdateUseCase(getIt()),
  );
}
