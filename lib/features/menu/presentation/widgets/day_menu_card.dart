import 'package:ManasYemek/features/dish/presentation/screens/dish_details_screen.dart';
import 'package:ManasYemek/features/menu/domain/entities/daily_menu_entity.dart';
import 'package:ManasYemek/features/menu/presentation/widgets/menu_item_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayMenuCard extends StatelessWidget {
  final DailyMenuEntity dayMenu;

  const DayMenuCard({super.key, required this.dayMenu});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getWeekdayFromDate(dayMenu.date, locale: Localizations.localeOf(context).languageCode),
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - 16 - 32) / 2;
              final itemHeight = itemWidth / 0.85;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: itemWidth / itemHeight,
                ),
                itemCount: dayMenu.items.length,
                itemBuilder: (context, index) {
                  final item = dayMenu.items[index];
                  return MenuItemCard(
                    item: item,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DishDetailsScreen(dish: item),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          const SizedBox(height: 20),
          _DayKcalAndDate(dayMenu: dayMenu),
        ],
      ),
    );
  }
}

String getWeekdayFromDate(String input, {required String locale}) {
  final date = DateTime.parse(input);
  return DateFormat.EEEE(locale).format(date);
}

String formatDateToMonthDay(String input, {required String locale}) {
  final date = DateTime.parse(input);
  return DateFormat.MMMMd(locale).format(date);
}

class _DayKcalAndDate extends StatelessWidget {
  final DailyMenuEntity dayMenu;

  const _DayKcalAndDate({required this.dayMenu});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 285),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${dayMenu.totalCalories} kcal',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              formatDateToMonthDay(dayMenu.date, locale: locale),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
