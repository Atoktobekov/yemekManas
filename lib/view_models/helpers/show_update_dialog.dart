import 'package:ManasYemek/models/models.dart';
import 'ui_event.dart';

class ShowUpdateDialog extends UiEvent {
  final UpdateInfo updateInfo;
  ShowUpdateDialog(this.updateInfo);
}