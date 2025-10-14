import 'package:flutter/foundation.dart';
import 'package:ManasYemek/models/models.dart';
import 'package:ManasYemek/services/api_service.dart';

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
    _errorMessage = '';
    notifyListeners();

    try {
      _menus = await _apiService.fetchMenu();
      _status = MenuStatus.loaded;
    } catch (e, st) {
      // Логируем полную ошибку в debug, чтобы видеть в adb logcat
      debugPrint('FetchMenu error: $e\n$st');
      _errorMessage = 'Не удалось загрузить меню. Попробуйте позже.';
      _menus = [];
      _status = MenuStatus.error;
    } finally {
      notifyListeners();
    }
  }
}
