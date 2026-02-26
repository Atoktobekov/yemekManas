import 'package:ManasYemek/core/error/exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:ManasYemek/features/menu/domain/entities/daily_menu_entity.dart';
import 'package:ManasYemek/features/menu/domain/repositories/menu_repository.dart';
import 'package:ManasYemek/features/menu/domain/usecases/get_menu_use_case.dart';
import 'package:talker_flutter/talker_flutter.dart';

enum MenuStatus { initial, loading, loaded, error }

class MenuProvider extends ChangeNotifier {
  final GetMenuUseCase _getMenuUseCase;
  final MenuRepository _menuRepository;
  final Talker _talker;

  MenuProvider({
    required GetMenuUseCase getMenuUseCase,
    required MenuRepository menuRepository,
    required Talker talker,
  }) : _getMenuUseCase = getMenuUseCase,
        _menuRepository = menuRepository,
        _talker = talker;

  factory MenuProvider.fromGetIt() {
    final getIt = GetIt.instance;
    return MenuProvider(
      getMenuUseCase: getIt<GetMenuUseCase>(),
      menuRepository: getIt<MenuRepository>(),
      talker: getIt<Talker>(),
    );
  }

  MenuStatus _status = MenuStatus.initial;
  List<DailyMenuEntity> _menus = [];
  String _message = '';

  MenuStatus get status => _status;
  List<DailyMenuEntity> get menus => _menus;
  String get message => _message;
  bool get isCached => _menuRepository.isDataFromCache();

  Future<void> fetchMenu() async {
    _status = MenuStatus.loading;
    _message = '';
    notifyListeners();

    try {
      _menus = await _getMenuUseCase();
      if (_menuRepository.isDataFromCache()) {
        _message = 'No internet connection. Showing saved data.';
      }
      _status = MenuStatus.loaded;
    } on DataExpiredException {
      _status = MenuStatus.error;
      _menus = [];
      _message = 'No internet connection and saved data is too old.';
    } catch (e, st) {
      _talker.handle(e, st);
      _status = MenuStatus.error;
      _menus = [];
      _message = 'Failed downloading menu. Please try again later';
    }

    notifyListeners();
  }
}
