import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  static const supportedLocales = [
    Locale('en'),
    Locale('ru'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static final Map<String, Map<String, String>> _strings = {
    'en': {
      'appTitleMenu': 'Yemekhane Menu',
      'tabCanteen': 'Canteen',
      'tabBuffet': 'Buffet',
      'buffetTitle': 'Buffet Menu',
      'errorTitle': 'Oops, this page is unavailable',
      'errorSubtitle': 'Something went wrong. Check internet and try again.',
      'retry': 'Try again',
      'noInternetCached': 'No internet connection. Showing saved data.',
      'dishDescriptionMissing': 'Description is not available yet.',
      'comments': 'Comments',
      'commentsLoadFail': 'Failed to load comments.',
      'commentsEmpty': 'No comments yet. Be the first!',
      'thanks': 'Thank you!',
      'ratingAccepted': 'Your rating was accepted 🙌',
      'commentTooLong': 'Comment is too long (max 200 chars)',
      'commentBlocked': 'Comment contains disallowed words',
      'menuLoadFailed': 'Failed downloading menu. Please try again later',
    },
    'ru': {
      'appTitleMenu': 'Yemekhane Menu',
      'tabCanteen': 'Столовая',
      'tabBuffet': 'Буфет',
      'buffetTitle': 'Меню буфета',
      'errorTitle': 'Упс, страница пока недоступна',
      'errorSubtitle': 'Что-то пошло не так. Проверьте интернет и попробуйте ещё раз.',
      'retry': 'Попробовать снова',
      'noInternetCached': 'Нет интернета. Показаны сохраненные данные.',
      'dishDescriptionMissing': 'Описание пока отсутствует.',
      'comments': 'Комментарии',
      'commentsLoadFail': 'Не удалось загрузить комментарии.',
      'commentsEmpty': 'Пока нет комментариев. Будьте первым!',
      'thanks': 'Спасибо!',
      'ratingAccepted': 'Ваша оценка принята 🙌',
      'commentTooLong': 'Комментарий слишком длинный (макс. 200 символов)',
      'commentBlocked': 'Комментарий содержит недопустимые выражения',
      'menuLoadFailed': 'Не удалось загрузить меню. Попробуйте позже',
    },
  };

  String tr(String key) {
    return _strings[locale.languageCode]?[key] ?? _strings['en']![key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}

extension AppLocalizationX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
