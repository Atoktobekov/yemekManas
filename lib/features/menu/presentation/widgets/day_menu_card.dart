import 'package:ManasYemek/features/dish/presentation/screens/dish_details_screen.dart';
import 'package:flutter/material.dart';

import 'package:ManasYemek/features/menu/domain/entities/daily_menu_entity.dart';
//import 'package:ManasYemek/features/menu/presentation/screens/dish_details_screen.dart';

import 'package:ManasYemek/features/menu/presentation/widgets/menu_item_card.dart';

class DayMenuCard extends StatelessWidget {
  final DailyMenuEntity dayMenu;

  const DayMenuCard({super.key, required this.dayMenu});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getWeekdayFromDate(dayMenu.date),
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
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
         _DayKcalAndDate(dayMenu: dayMenu)
        ],
      ),
    );
  }
}

String getWeekdayFromDate(String input) {
  final date = DateTime.parse(input);
  const weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  return weekdays[date.weekday - 1];
}

String formatDateToMonthDay(String input) {
  final date = DateTime.parse(input);
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  return '${months[date.month - 1]} ${date.day}';
}

class _DayKcalAndDate extends StatelessWidget {
  final DailyMenuEntity dayMenu;

  const _DayKcalAndDate({required this.dayMenu});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 285),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(4),
              offset: const Offset(0, 6),
              blurRadius: 5,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${dayMenu.totalCalories} kcal',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              formatDateToMonthDay(dayMenu.date),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
