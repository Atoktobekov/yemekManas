import 'package:ManasYemek/core/di/service_locator.dart';
import 'package:ManasYemek/core/error/failures.dart';
import 'package:ManasYemek/features/buffet/domain/entities/buffet_menu_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:ManasYemek/features/buffet/domain/usecases/get_buffet_menu_usecase.dart';

enum BuffetStatus { initial, loading, loaded, error }

class BuffetProvider extends ChangeNotifier {
  final GetBuffetMenuUseCase _useCase;

  BuffetProvider(this._useCase);

  factory BuffetProvider.fromGetIt() {
    return BuffetProvider(getIt<GetBuffetMenuUseCase>());
  }

  BuffetStatus _status = BuffetStatus.initial;
  BuffetMenuEntity? _menu;
  String _errorMessage = '';

  BuffetStatus get status => _status;
  BuffetMenuEntity? get menu => _menu;
  String get errorMessage => _errorMessage;

  Future<void> loadMenu() async {
    if (_status == BuffetStatus.loading) return;

    _status = BuffetStatus.loading;
    _errorMessage = '';
    notifyListeners();

    final result = await _useCase();

    result.fold((failure) {
      _errorMessage = _mapFailureToMessage(failure);
      _status = BuffetStatus.error;
      _menu = null;
    }, (menu) {
      _menu = menu;
      _status = BuffetStatus.loaded;
    });
    notifyListeners();
}
  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure || failure is ServerFailure) {
      return failure.message;
    }

    return 'Failed to load buffet menu. Please try again later';
  }
}