import 'package:flutter/material.dart';
import '../../models/daily_menu.dart';
import '../../services/format_date_service.dart';
import 'menu_item_tile.dart';

class DayCard extends StatelessWidget {
  final DailyMenu dayMenu;

  const DayCard({required this.dayMenu, super.key});

  @override
  Widget build(BuildContext context) {
    final dateText = dayMenu.date.isNotEmpty ? formatDate(dayMenu.date) : 'Дата неизвестна';

    return Card(
      key: ValueKey(dateText),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dateText, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (dayMenu.items.isEmpty)
              const Text('Меню отсутствует', style: TextStyle(color: Colors.grey))
            else
              Column(
                children: dayMenu.items
                    .map((item) => Column(
                  children: [
                    MenuItemTile(item: item,),
                    const Divider(height: 1),
                   ],
                ))
                    .toList(),
              ),
            SizedBox(height: 8),
            Text(
              'Суммарно: ${dayMenu.items.fold<int>(0, (sum, item) => sum + item.caloriesCount)} kcal', style: Theme.of(context).textTheme.headlineMedium,),

          ],
        ),
      ),
    );
  }
}
