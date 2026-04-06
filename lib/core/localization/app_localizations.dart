import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  static const supportedLocales = [
    Locale('en'),
    Locale('ru'),
    Locale('tr'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _strings = {
    'en': {
      'appTitleMenu': 'Yemekhane Menu',
      'commentPlaceholder': 'Write a comment...',
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
      'settings': 'Settings',
      'theme': 'Theme',
      'themeSystem': 'System',
      'themeLight': 'Light',
      'themeDark': 'Dark',
      'language': 'Language',
      'languageSystem': 'System',
      'madeForManas': 'Made for Manas University',
      'version': 'Version',
      'updateAvailable': 'Update is available',
      'newVersion': 'New version',
      'whatsNew': "What's new",
      'later': 'Later',
      'update': 'Update',
      'installPermissionTitle': 'Install permission',
      'installPermissionBody': 'Permission is needed to install a new app version.',
      'cancel': 'Cancel',
      'allow': 'Allow',
      'updateReady': 'Update is ready',
      'updateReadyBody': 'The new version has been downloaded. Tap Install.',
      'install': 'Install',
      'openSettings': 'Open settings',
      'openSettingsBody': 'Permission denied. Enable app installs in system settings.',
      'openSettingsAction': 'Settings',
    },
    'ru': {
      'appTitleMenu': 'Меню столовой',
      'commentPlaceholder': 'Написать комментарий...',
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
      'settings': 'Настройки',
      'theme': 'Тема',
      'themeSystem': 'Системная',
      'themeLight': 'Светлая',
      'themeDark': 'Тёмная',
      'language': 'Язык',
      'languageSystem': 'Системный',
      'madeForManas': 'Сделано для Manas University',
      'version': 'Версия',
      'updateAvailable': 'Доступно обновление',
      'newVersion': 'Новая версия',
      'whatsNew': 'Что нового',
      'later': 'Позже',
      'update': 'Обновить',
      'installPermissionTitle': 'Разрешение на установку',
      'installPermissionBody': 'Нужно разрешение для установки новой версии приложения.',
      'cancel': 'Отмена',
      'allow': 'Разрешить',
      'updateReady': 'Обновление готово',
      'updateReadyBody': 'Новая версия загружена. Нажмите «Установить».',
      'install': 'Установить',
      'openSettings': 'Открыть настройки',
      'openSettingsBody': 'Доступ запрещён. Разрешите установку приложения в системных настройках.',
      'openSettingsAction': 'Настройки',
    },
    'tr': {
      'appTitleMenu': 'Yemekhane Menüsü',
      'commentPlaceholder': 'Yorum yazın...',
      'tabCanteen': 'Yemekhane',
      'tabBuffet': 'Büfe',
      'buffetTitle': 'Büfe Menüsü',
      'errorTitle': 'Ups, bu sayfa şu anda kullanılamıyor',
      'errorSubtitle': 'Bir şeyler yanlış gitti. İnternetinizi kontrol edip tekrar deneyin.',
      'retry': 'Tekrar dene',
      'noInternetCached': 'İnternet yok. Kayıtlı veriler gösteriliyor.',
      'dishDescriptionMissing': 'Açıklama henüz mevcut değil.',
      'comments': 'Yorumlar',
      'commentsLoadFail': 'Yorumlar yüklenemedi.',
      'commentsEmpty': 'Henüz yorum yok. İlk yorumu siz yapın!',
      'thanks': 'Teşekkürler!',
      'ratingAccepted': 'Puanınız alındı 🙌',
      'commentTooLong': 'Yorum çok uzun (en fazla 200 karakter)',
      'commentBlocked': 'Yorum uygun olmayan ifadeler içeriyor',
      'menuLoadFailed': 'Menü yüklenemedi. Lütfen daha sonra tekrar deneyin',
      'settings': 'Ayarlar',
      'theme': 'Tema',
      'themeSystem': 'Sistem',
      'themeLight': 'Açık',
      'themeDark': 'Koyu',
      'language': 'Dil',
      'languageSystem': 'Sistem',
      'madeForManas': 'Manas University için yapıldı',
      'version': 'Sürüm',
      'updateAvailable': 'Güncelleme mevcut',
      'newVersion': 'Yeni sürüm',
      'whatsNew': 'Yenilikler',
      'later': 'Sonra',
      'update': 'Güncelle',
      'installPermissionTitle': 'Yükleme izni',
      'installPermissionBody': 'Uygulamanın yeni sürümünü kurmak için izin gerekli.',
      'cancel': 'İptal',
      'allow': 'İzin ver',
      'updateReady': 'Güncelleme hazır',
      'updateReadyBody': 'Yeni sürüm indirildi. Kur seçeneğine dokunun.',
      'install': 'Kur',
      'openSettings': 'Ayarları aç',
      'openSettingsBody': 'İzin reddedildi. Sistem ayarlarında uygulama kurulumu iznini açın.',
      'openSettingsAction': 'Ayarlar',
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
