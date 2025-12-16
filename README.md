# Yemekhane Manas 🍛

**Yemekhane Manas** — a Flutter mobile application for students of Manas University and the Kyrgyz-Turkish University, allowing them to view the cafeteria menu for today and several days ahead.  

The app focuses on convenience and beautifully displaying information about dishes: photos, calories, and date of the menu.

---

## 📱 Features

- View menu for multiple days ahead.
- Beautiful cards for dishes with images, name, and calorie count.
- Total calories per day.
- **In-app update system**: The app checks for new versions and allows users to download and install updates seamlessly without visiting an app store.
- **Offline Caching**: The menu is cached locally, allowing users to view it even without an internet connection.
- Error handling for data and image loading.

---

## 🧩 Technologies

- [Flutter](https://flutter.dev/) (SDK 3.x)
- **Firebase Remote Config** — For remote configuration and managing the in-app update system.
- **GetIt** — Service Locator for dependency injection.
- [Dio](https://pub.dev/packages/dio) — HTTP client for REST API.
- [Hive_ce](https://pub.dev/packages/hive_ce_flutter) — Fast, lightweight, and NoSQL database for data caching.
- [Talker](https://pub.dev/packages/talker_flutter) — Advanced logger and error handler.

---

## 📸 Screenshots


<p align="center">
  <img src="screenshots/Yemekhane2.png" width="35%">
  <img src="screenshots/Yemekhane1.png" width="35%">  
</p>

---

## 📁 Project Structure

Project is using standard MVVM pattern. 

- 🧩models/ — Data models (MenuItem, DailyMenu).

- 👓view_models/ — Handles state management and business logic.

- 🔗services/ — API service using Dio and FormatDate service using intl.dart

- 👀screens/ — UI screens that consume the ViewModel.


---

🌐 API

- Using public API: [YemekManas](https://yemek-api.vercel.app/)

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

 ## 📜 License

  Apache 2.0 License  © [Atoktobekov](https://github.com/Atoktobekov)  
