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

  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  Future<void> fetchMenu() async {
    _status = MenuStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      _menus = await GetIt.instance<MenuRepository>().getMenuList();
      if (_menus.isNotEmpty) {
        _status = MenuStatus.loaded;
      }
      else {
        _errorMessage = 'Failed downloading menu. Please try again later';
        _menus = [];
        _status = MenuStatus.error;
      }
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      _errorMessage = 'Failed downloading menu. Please try again later';
      _menus = [];
      _status = MenuStatus.error;
    } finally {
      notifyListeners();
    }
  }
}
