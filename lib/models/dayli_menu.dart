import 'menu_item.dart';

class DailyMenu {
  final String date;
  final List<MenuItem> items;

  DailyMenu({required this.date, required this.items});

  factory DailyMenu.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List;
    List<MenuItem> items = list.map((i) => MenuItem.fromJson(i)).toList();

    return DailyMenu(
      date: json['at'],
      items: items,
    );
  }
}