import 'package:ManasYemek/exceptions/data_expired_exception.dart';
import 'package:ManasYemek/exceptions/network_exception.dart';
import 'package:get_it/get_it.dart';
import 'package:ManasYemek/models/models.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:ManasYemek/services/services.dart';
import 'package:talker_flutter/talker_flutter.dart';

class MenuRepository {
  final Box<DailyMenu> yemekListBox;
  final ApiService2 apiService;
  bool _isDataFromCacheFlag = false;

  MenuRepository({required this.apiService, required this.yemekListBox});

  Future<List<DailyMenu>> getMenuList() async {
    var menuList = <DailyMenu>[];

    try {
      menuList = await apiService.fetchMenu();

      //saving data in HiveBox
      final menuListMap = {for (var e in menuList) e.date: e};
      yemekListBox.putAll(menuListMap);

      _isDataFromCacheFlag = false;
      return menuList;
    } on NetworkException catch (e) {
      GetIt.instance<Talker>().handle(e);
      _isDataFromCacheFlag = true;

      final cachedData = getCachedMenu();

      //TTL Filtering
      final freshData = _filterFresh(cachedData);

      if (freshData.isNotEmpty) {
        GetIt.instance<Talker>().info("Using cached menu data");
        return freshData;
      }
      throw DataExpiredException();
    } catch (e, st) {
      GetIt.instance<Talker>().handle(
        e,
        st,
        "[getMenuListError from MenuRepository]",
      );
      rethrow;
    }
  }

  List<DailyMenu> getCachedMenu() {
    return yemekListBox.values.toList();
  }

  bool isDataFromCache() => _isDataFromCacheFlag;

  List<DailyMenu> _filterFresh(List<DailyMenu> data) {
    return data.where((e) {
      final age = DateTime.now().difference(e.lastUpdate);
      return age.inMinutes <= 60;
    }).toList();
  }

}
