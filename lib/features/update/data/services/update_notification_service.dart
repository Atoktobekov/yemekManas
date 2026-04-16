import 'package:ManasYemek/features/update/domain/entities/update_task_state.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class UpdateNotificationService {
  static const String _channelId = 'update_pipeline_channel';
  static const int _notificationId = 7342;

  final FlutterLocalNotificationsPlugin _plugin;

  UpdateNotificationService(this._plugin);

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/launcher_icon');
    await _plugin.initialize(const InitializationSettings(android: android));

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            'App Updates',
            description: 'Shows update download and installation status',
            importance: Importance.high,
          ),
        );
  }

  Future<void> showState(UpdateTaskState state) async {
    final (title, body, progress, indeterminate) = _mapState(state);

    final android = AndroidNotificationDetails(
      _channelId,
      'App Updates',
      channelDescription: 'Shows update download and installation status',
      importance: Importance.high,
      priority: Priority.high,
      onlyAlertOnce: true,
      showProgress: progress != null || indeterminate,
      maxProgress: 100,
      progress: progress ?? 0,
      indeterminate: indeterminate,
    );

    await _plugin.show(
      _notificationId,
      title,
      body,
      NotificationDetails(android: android),
    );
  }

  Future<void> clear() async {
    await _plugin.cancel(_notificationId);
  }

  (String, String, int?, bool) _mapState(UpdateTaskState state) {
    switch (state.status) {
      case UpdateTaskStatus.queued:
        return ('Обновление', 'Подготовка к загрузке...', null, true);
      case UpdateTaskStatus.downloading:
        return (
          'Обновление',
          'Скачивание ${(state.progress * 100).toStringAsFixed(0)}%',
          (state.progress * 100).clamp(0, 100).round(),
          false,
        );
      case UpdateTaskStatus.interrupted:
        return ('Обновление', 'Скачивание прервано, можно продолжить', null, false);
      case UpdateTaskStatus.extracting:
        return ('Обновление', 'Распаковка архива...', null, true);
      case UpdateTaskStatus.readyToInstall:
        return ('Обновление готово', 'Нажмите для установки новой версии', null, false);
      case UpdateTaskStatus.installing:
        return ('Обновление', 'Открываем установщик...', null, true);
      case UpdateTaskStatus.completed:
        return ('Обновление', 'Установка запущена', null, false);
      case UpdateTaskStatus.failed:
        return ('Обновление не удалось', state.failureReason ?? 'Неизвестная ошибка', null, false);
      case UpdateTaskStatus.idle:
        return ('Обновление', 'Ожидание', null, false);
    }
  }
}
