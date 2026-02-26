import 'package:ManasYemek/core/error/exceptions.dart';
import 'package:ManasYemek/core/network/network_info.dart';
import 'package:ManasYemek/features/menu/data/datasources/menu_local_data_source.dart';
import 'package:ManasYemek/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:ManasYemek/features/menu/domain/entities/daily_menu_entity.dart';
import 'package:ManasYemek/features/menu/domain/repositories/menu_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource _remoteDataSource;
  final MenuLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final Talker _talker;

  bool _isDataFromCacheFlag = false;

  MenuRepositoryImpl({
    required MenuRemoteDataSource remoteDataSource,
    required MenuLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
    required Talker talker,
  }) : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo,
        _talker = talker;

  @override
  Future<List<DailyMenuEntity>> getMenus() async {
    try {
      final menus = await _remoteDataSource.fetchMenus();
      await _localDataSource.saveMenus(menus);
      _isDataFromCacheFlag = false;
      return menus;
    } catch (e, st) {
      _talker.handle(e, st, '[MenuRepositoryImpl] falling back to cache');

      final hasInternet = await _networkInfo.isConnected;
      if (hasInternet) {
        rethrow;
      }

      _isDataFromCacheFlag = true;
      final freshData = _filterFresh(_localDataSource.getCachedMenus());
      if (freshData.isNotEmpty) {
        return freshData;
      }

      throw DataExpiredException();
    }
  }

  @override
  bool isDataFromCache() => _isDataFromCacheFlag;

  List<DailyMenuEntity> _filterFresh(List<DailyMenuEntity> data) {
    return data.where((menu) {
      final age = DateTime.now().difference(menu.lastUpdate);
      return age.inMinutes <= 60;
    }).toList();
  }
}
