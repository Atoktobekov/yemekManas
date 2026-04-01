import 'package:ManasYemek/core/di/service_locator.dart';
import 'package:ManasYemek/features/buffet/domain/entities/buffet_menu_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:ManasYemek/features/buffet/domain/usecases/get_buffet_menu_usecase.dart';

enum BuffetStatus { initial, loading, loaded, error }

class BuffetProvider extends ChangeNotifier {
  final GetBuffetMenuUseCase _useCase;

  BuffetProvider(this._useCase);

  /// Удобный фабричный конструктор — в стиле твоих MenuProvider.fromGetIt()
  factory BuffetProvider.fromGetIt() {
    return BuffetProvider(getIt<GetBuffetMenuUseCase>());
  }

  BuffetStatus _status = BuffetStatus.initial;
  BuffetMenuEntity? _menu;
  String? _errorMessage;

  BuffetStatus get status => _status;
  BuffetMenuEntity? get menu => _menu;
  String? get errorMessage => _errorMessage;

  Future<void> loadMenu() async {
    if (_status == BuffetStatus.loading) return; // защита от двойного вызова

    _status = BuffetStatus.loading;
    notifyListeners();

    try {
      _menu = await _useCase();
      _status = BuffetStatus.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _status = BuffetStatus.error;
    }

    notifyListeners();
  }
}