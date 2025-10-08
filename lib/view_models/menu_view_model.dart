import 'package:flutter/foundation.dart';
import 'package:manas_yemek/models/models.dart';
import '../services/api_service.dart';

enum MenuStatus { initial, loading, loaded, error }

class MenuViewModel extends ChangeNotifier {
  final ApiService _apiService;

  MenuViewModel(this._apiService);

  MenuStatus _status = MenuStatus.initial;
  MenuStatus get status => _status;

  List<DailyMenu> _menus = [];
  List<DailyMenu> get menus => _menus;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchMenu() async {
    _status = MenuStatus.loading;
    notifyListeners();

    try {
      _menus = await _apiService.fetchMenu();
      _status = MenuStatus.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _status = MenuStatus.error;
    }

    notifyListeners();
  }
}
