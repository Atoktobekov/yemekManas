import 'ui_event.dart';

class ShowSnackbar extends UiEvent {
  final String message;
  ShowSnackbar(this.message);
}