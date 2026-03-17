import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:talker_flutter/talker_flutter.dart';

class AnalyticsTalkerObserver extends TalkerObserver {
  AnalyticsTalkerObserver({
    required this.analytics,
  });

  final FirebaseAnalytics analytics;

  @override
  void onError(TalkerError err) {
    _sendErrorToAnalytics(err.error as Object, err.stackTrace, 'error');
  }

  @override
  void onException(TalkerException exc) {
    _sendErrorToAnalytics(exc.exception ?? Exception("Unknown exception"), exc.stackTrace, 'exception');
  }

  void _sendErrorToAnalytics(Object error, StackTrace? stack, String type) {
    // Логируем ошибку как кастомное событие
    analytics.logEvent(
      name: 'app_error',
      parameters: {
        'error_type': type,
        'error_message': error.toString().take(100), // Ограничим длину для Firebase
      },
    );

    // Если у тебя подключен Firebase Crashlytics,
    // здесь же можно вызвать FirebaseCrashlytics.instance.recordError
  }
}

// Полезный хелпер для обрезки строк
extension StringExtension on String {
  String take(int n) => length <= n ? this : substring(0, n);
}