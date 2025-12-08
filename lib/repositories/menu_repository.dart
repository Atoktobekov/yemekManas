import 'package:get_it/get_it.dart';
import 'package:ManasYemek/models/models.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:ManasYemek/services/services.dart';
import 'package:talker_flutter/talker_flutter.dart';

bool _isDataFromCacheFlag = false;

class MenuRepository {
  final Box<DailyMenu> yemekListBox;
  final ApiService2 apiService;

  MenuRepository({required this.apiService, required this.yemekListBox});

  Future<List<DailyMenu>> getMenuList() async {
    var menuList = <DailyMenu>[];

    try {
      menuList = await apiService.fetchMenu();
      final menuListMap = {for (var e in menuList) e.date: e};
      yemekListBox.putAll(menuListMap);

      _isDataFromCacheFlag = false;
      return menuList;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st, "[getMenuListError from MenuRepository]");
      _isDataFromCacheFlag = true;
      return getCachedMenu();
    }
  }

  List<DailyMenu> getCachedMenu(){
    return yemekListBox.values.toList();
  }

  bool isDataFromCache(){
    return _isDataFromCacheFlag;
  }
}
