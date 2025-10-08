# Manas Yemek App 🍛

A simple Flutter application that retrieves daily meal menus from a public API and displays them in a user-friendly interface.

---

## 🍀   Features

- Display daily menus with items and calories.
- Pull-to-refresh support to reload the menu.
- Cached images for better performance using `cached_network_image`.
- Error handling for network failures.
- Clean MVVM architecture with separation of concerns:
  - **Model**: `MenuItem`, `DailyMenu`.
  - **ViewModel**: `MenuViewModel`.
  - **View**: `MenuScreen`.

---

## 🧩 Technologies

- [Flutter](https://flutter.dev/) (SDK 3.x)  
- [Dio](https://pub.dev/packages/dio) — HTTP client for REST API  
- **JSON Serialization** — data transformation into models  
- **Material Design** — visual interface style  

---

## 📁 Project Structure

lib/  
├── models/  
│   ├── menu_item.dart  
│   └── daily_menu.dart  
├── view_models/  
│   └── menu_view_model.dart  
├── services/  
│   └── api_service.dart  
└── screens/  
    └── menu_screen.dart  

- 🧩models/ — Data models (MenuItem, DailyMenu).

- 👓view_models/ — Handles state management and business logic.

- 🔗services/ — API service using Dio.

- 👀screens/ — UI screens that consume the ViewModel.


---

🌐 API

- Using public API: [YemekManas](https://yemek-api.vercel.app/)

 ---

## 🔗 Dependencies

- [Provider](https://pub.dev/packages/provider)
- [Dio](https://pub.dev/packages/dio)
- [ImageCaching](https://pub.dev/packages/cached_network_image)

 ---

 ## 📜 License

  Apache 2.0 License  © [Atoktobekov](https://github.com/Atoktobekov)  