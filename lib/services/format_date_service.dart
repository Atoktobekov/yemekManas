import 'package:intl/intl.dart';

String formatDate(String raw) {
  // raw — например ISO string, лучше хранить DateTime в модели
  try {
    final dt = DateTime.parse(raw);
    final now = DateTime.now();
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'Bugün';
    }
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day+1 || dt.year == now.year && dt.month == now.month+1 && dt.day == 1 || dt.year == now.year+1 && dt.month == 1 && dt.day == 1) {
      return 'Yarın';
    }
    final fmt = DateFormat('EEEE, d MMM', 'ru');
    return toBeginningOfSentenceCase(fmt.format(dt)) ?? fmt.format(dt);
  } catch (_) {
    return raw; // fallback
  }
}