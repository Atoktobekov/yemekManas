import 'menu_item.dart';

class DailyMenu {
  final String date;
  final List<MenuItem> items;

  DailyMenu({
    required this.date,
    required this.items,
  });

  factory DailyMenu.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List;
    final itemsList = itemsJson.map((e) => MenuItem.fromJson(e)).toList();
    return DailyMenu(
      date: json['at'],
      items: itemsList,
    );
  }
}
