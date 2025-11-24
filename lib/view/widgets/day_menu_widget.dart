import 'package:flutter/material.dart';
import 'package:ManasYemek/models/models.dart';
import 'package:ManasYemek/view/view.dart';

class DayMenuWidget extends StatelessWidget {
  final DailyMenu dayMenu;

  const DayMenuWidget({super.key, required this.dayMenu});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EE),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            offset: const Offset(0, 6),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getWeekdayFromDate(dayMenu.date),
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: dayMenu.items.length,
            itemBuilder: (context, index) {
              return MenuItemWidget(item: dayMenu.items[index]);
            },
          ),
          const SizedBox(height: 20),
          _DayKcalAndDate(dayMenu: dayMenu),
        ],
      ),
    );
  }
}

class _DayKcalAndDate extends StatelessWidget {
  final DailyMenu dayMenu;

  const _DayKcalAndDate({required this.dayMenu});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(22),
            offset: const Offset(0, 6),
            blurRadius: 13,
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
    );
  }
}

String getWeekdayFromDate(String input) {
  final parts = input.split('-');
  final day = int.parse(parts[2]);
  final month = int.parse(parts[1]);
  final year = int.parse(parts[0]);

  final date = DateTime(year, month, day);

  const weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  return weekDays[date.weekday - 1];
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

  final monthName = months[date.month - 1];
  return "$monthName ${date.day}";
}
