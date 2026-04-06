import 'package:ManasYemek/core/config/cache_config.dart';
import 'package:ManasYemek/core/network/network_info.dart';
import 'package:ManasYemek/features/menu/data/datasources/menu_local_data_source.dart';
import 'package:ManasYemek/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:ManasYemek/features/menu/domain/entities/daily_menu_entity.dart';
import 'package:ManasYemek/features/menu/domain/repositories/menu_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:ManasYemek/core/error/failure_mapper.dart';
import 'package:ManasYemek/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource _remoteDataSource;
  final MenuLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final Talker _talker;
  final CacheConfig _cacheConfig;

  bool _isDataFromCacheFlag = false;

  MenuRepositoryImpl({
    required MenuRemoteDataSource remoteDataSource,
    required MenuLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
    required Talker talker,
    required CacheConfig cacheConfig,
  }) : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo,
        _talker = talker,
        _cacheConfig = cacheConfig;

  @override
  Future<Either<Failure, List<DailyMenuEntity>>> getMenus({required String localeCode}) async {
    try {
      final responseModel = await _remoteDataSource.fetchMenus();
      final menus = responseModel.toEntities(locale: localeCode);
      await _localDataSource.saveMenus(menus);
      _isDataFromCacheFlag = false;
      return Right(menus);
    } catch (e) {
      /// here I should log the error with stacktrace, but I'm sending null
      _talker.handle(e, null, '[MenuRepositoryImpl] falling back to cache');

      final hasInternet = await _networkInfo.isConnected;
      if (hasInternet) {
        return Left(mapExceptionToFailure(e));
      }

      _isDataFromCacheFlag = true;
      final freshData = _filterFresh(_localDataSource.getCachedMenus());
      if (freshData.isNotEmpty) {
        return Right(freshData);
      }

      return const Left(DataExpiredFailure());
    }
  }

  @override
  bool isDataFromCache() => _isDataFromCacheFlag;

  List<DailyMenuEntity> _filterFresh(List<DailyMenuEntity> data) {
    return data.where((menu) {
      final age = DateTime.now().difference(menu.lastUpdate);
      return age <= _cacheConfig.menuTTL;
    }).toList();
  }
}
