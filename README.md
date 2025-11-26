# Yemekhane Manas 🍛

**Yemekhane Manas** — a Flutter mobile application for students of Manas University and the Kyrgyz-Turkish University, allowing them to view the cafeteria menu for today and several days ahead.  

The app focuses on convenience and beautifully displaying information about dishes: photos, calories, and date of the menu.

---

## 📱 Features

- View menu for multiple days ahead.
- Beautiful cards for dishes with images, name, and calorie count.
- Total calories per day.
- Error handling for data and image loading.

---

## 🧩 Technologies

- [Flutter](https://flutter.dev/) (SDK 3.x)  
- [Dio](https://pub.dev/packages/dio) — HTTP client for REST API  
- [Provider](https://pub.dev/packages/provider) - State management

---

## 📁 Project Structure

lib/  
├── main.dart - **Application entry point**  
├── app.dart - **App file**  
├── theme/  
│ └── theme.dart - **App theme**  
├── models/  
│ ├── models.dart - **Export of all models**  
│ ├── daily_menu.dart - **DailyMenu model**  
│ └── menu_item.dart - **MenuItem model**  
├── services/  
│ └── api_service2.dart - **API communication**  
├── view_models/  
│ └── menu_view_model.dart - **ViewModel for menu and UI state**  
└── screens/  
└── menu_screen.dart - **Main screen with vertical paging**  
└── widgets/  
├── menu_item_widget.dart - **Card with details of one meal**  
├── day_menu_widget.dart - **Widget for displaying a day's menu**  
└── widgets.dart - **Export for all widget files**

- 🧩models/ — Data models (MenuItem, DailyMenu).

- 👓view_models/ — Handles state management and business logic.

- 🔗services/ — API service using Dio and FormatDate service using intl.dart

- 👀screens/ — UI screens that consume the ViewModel.


---

🌐 API

- Using public API: [YemekManas](https://yemek-api.vercel.app/)

 ---

## 🔗 Dependencies

- [Provider](https://pub.dev/packages/provider)
- [Dio](https://pub.dev/packages/dio)
- [ImageCaching](https://pub.dev/packages/cached_network_image)
- [intl](https://pub.dev/packages/intl)

 ---

 ## 📜 License

  Apache 2.0 License  © [Atoktobekov](https://github.com/Atoktobekov)  
