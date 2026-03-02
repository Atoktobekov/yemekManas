# Yemekhane Manas 🍛

**Yemekhane Manas** — Flutter-приложение для студентов **Manas University** и **Kyrgyz-Turkish University**, позволяющее просматривать меню столовой на сегодня и на несколько дней вперёд.  

Приложение делает акцент на удобстве и красивой подаче информации: фото блюд, калорийность и дата меню.  

---

## 📱 Features

- 📅 Просмотр меню на несколько дней вперёд  
- 🍔 Красивые карточки блюд с фото, названием и калориями  
- 🔢 Подсчёт общих калорий за день  
- ⬆️ **In-app Update System** — проверка обновлений, скачивание и установка без перехода в App Store  
- 💾 **Offline Caching** — кэширование меню для работы без интернета  
- ⚠️ Обработка ошибок при загрузке данных и изображений  
- 🧩 Архитектура **Clean Architecture**: разделение на **Domain, Data, Presentation**  

---

## 🧩 Technologies

- [Flutter](https://flutter.dev/) (SDK 3.x)  
- **Firebase Remote Config** — управление настройками и обновлениями приложения  
- **GetIt** — Service Locator для внедрения зависимостей  
- [Dio](https://pub.dev/packages/dio) — HTTP-клиент для REST API  
- [Hive_ce](https://pub.dev/packages/hive_ce_flutter) — быстрый локальный NoSQL-кэш данных  
- [Talker](https://pub.dev/packages/talker_flutter) — продвинутый логгер и обработчик ошибок  


---

## 🌐 API

- Публичный API: [YemekManas](https://manas-menu-back-adi-fork.vercel.app/)  

---

## 📸 Screenshots

<p align="center">
  <img src="screenshots/Yemekhane2.png" width="35%">
  <img src="screenshots/Yemekhane1.png" width="35%">
</p>

---

## 🔗 Dependencies

- [firebase_remote_config](https://pub.dev/packages/firebase_remote_config)  
- [get_it](https://pub.dev/packages/get_it)  
- [dio](https://pub.dev/packages/dio)  
- [cached_network_image](https://pub.dev/packages/cached_network_image)  
- [hive_ce_flutter](https://pub.dev/packages/hive_ce_flutter)  
- [talker_flutter](https://pub.dev/packages/talker_flutter)  
- [intl](https://pub.dev/packages/intl)  

---

## 📝 Notes

- Полная миграция на **Clean Architecture**: domain/data/presentation слои  
- Провайдеры (Provider) используются для управления состоянием UI  
- Локальная кэш-память Hive полностью интегрирована с фичей меню  
- Система обновлений работает через Remote Config и платформенные сервисы  

---

## 📜 License

Apache 2.0 License © [Atoktobekov](https://github.com/Atoktobekov)  
