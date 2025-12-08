import 'package:ManasYemek/repositories/menu_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:ManasYemek/models/models.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

enum MenuStatus { initial, loading, loaded, error }

class MenuViewModel extends ChangeNotifier {
  MenuStatus _status = MenuStatus.initial;

  MenuStatus get status => _status;

  List<DailyMenu> _menus = [];

  List<DailyMenu> get menus => _menus;

  String _message = '';

  String get message => _message;

  Future<void> fetchMenu() async {
    _status = MenuStatus.loading;
    _message = '';
    notifyListeners();

    try {
      _menus = await GetIt.instance<MenuRepository>().getMenuList();

      if(GetIt.instance<MenuRepository>().isDataFromCache()){
        final cachedData = GetIt.instance<MenuRepository>().getCachedMenu();

        _menus = cachedData.where((element) {
          final age = DateTime.now().difference(element.lastUpdate);
          return age.inMinutes <= 60;
        }).toList();

        if (_menus.isNotEmpty) {
          _status = MenuStatus.loaded;
          _message = "No internet connection. Showing saved data.";
        } else {
          _message = 'No internet connection and saved data is too old.';
          _menus = [];
          _status = MenuStatus.error;
        }
      }
      else{
        _status = MenuStatus.loaded;
        _message = "";
      }

    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      _message = 'Failed downloading menu. Please try again later';
      _menus = [];
      _status = MenuStatus.error;
    } finally {
      notifyListeners();
    }
  }
}
