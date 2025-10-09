import 'menu_item.dart';

class DailyMenu {
  final String date;
  final List<MenuItem> items;

  DailyMenu({
    required this.date,
    required this.items,
  });

  factory DailyMenu.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return DailyMenu(date: '', items: []);
    }

    final date = json['at']?.toString() ?? '';

    final itemsJson = json['items'] as List? ?? [];
    final itemsList = itemsJson
        .map((e) => MenuItem.fromJson(e as Map<String, dynamic>?))
        .toList();

    return DailyMenu(date: date, items: itemsList);
  }
}
