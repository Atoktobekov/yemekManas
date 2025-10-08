# Manas Yemek App 🍛

A simple Flutter application that retrieves daily meal menus from a public API and displays them in a user-friendly interface.

---

## 🚀 Features

- Fetching menu data using **Dio**
- Model architecture (`menu_item.dart`, `dayli_menu.dart`)
- Asynchronous loading and error handling
- Data refresh support
- Ready-made structure for project scaling

---

## 🧩 Technologies

- [Flutter](https://flutter.dev/) (SDK 3.x)  
- [Dio](https://pub.dev/packages/dio) — HTTP client for REST API  
- **JSON Serialization** — data transformation into models  
- **Material Design** — visual interface style  

---

## 📁 Project Structure

- lib/
- ├── models/
- │ ├── menu_item.dart - **single meal model**
- │ └── dayli_menu.dart - **daily menu model**
- ├── services/
- │ └── api_service.dart - **API operations using Dio**
- ├── screens/
- │ └── ... - **application UI screens**
- └── main.dart - **entry point**

---

🌐 API

- Using public API: [YemekManas](https://yemek-api.vercel.app/)

 ---

 ## License

  Apache 2.0 License  © [Atoktobekov](https://github.com/Atoktobekov)  