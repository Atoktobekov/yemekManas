import 'package:ManasYemek/features/dish/presentation/screens/dish_details_screen.dart';
import 'package:flutter/material.dart';

import 'package:ManasYemek/features/menu/domain/entities/daily_menu_entity.dart';

import 'package:ManasYemek/features/menu/presentation/widgets/menu_item_card.dart';

class DayMenuCard extends StatelessWidget {
  final DailyMenuEntity dayMenu;

  const DayMenuCard({super.key, required this.dayMenu});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                getWeekdayFromDate(dayMenu.date),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                formatDateToMonthDay(dayMenu.date),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
          _DayKcal(dayMenu: dayMenu),
        ],
      ),
    );
  }
}

String getWeekdayFromDate(String input) {
  final date = DateTime.parse(input);
  const weekdays = [
    'Понедельник',
    'Вторник',
    'Среда',
    'Четверг',
    'Пятница',
    'Суббота',
    'Воскресенье',
  ];
  return weekdays[date.weekday - 1];
}

String formatDateToMonthDay(String input) {
  final date = DateTime.parse(input);
  const months = [
    'Январь',
    'Февраль',
    'Март',
    'Апрель',
    'Май',
    'Июнь',
    'Июль',
    'Август',
    'Сентябрь',
    'Октябрь',
    'Ноябрь',
    'Декабрь',
  ];

  return '${months[date.month - 1]} ${date.day}';
}

class _DayKcal extends StatelessWidget {
  final DailyMenuEntity dayMenu;

  const _DayKcal({required this.dayMenu});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: theme.dividerColor.withValues(alpha: isDark ? 0.28 : 0.08),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Всего: ",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
            ),
            Text(
              '${dayMenu.totalCalories} Ккал',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
