import 'package:flutter/material.dart';

import 'package:ManasYemek/features/menu/domain/entities/daily_menu_entity.dart';
import 'package:ManasYemek/features/menu/presentation/widgets/day_menu_card.dart';

class StaggeredDayMenuCard extends StatelessWidget {
  final DailyMenuEntity dayMenu;
  final int index;
  final Animation<double> animation;

  const StaggeredDayMenuCard({
    super.key,
    required this.dayMenu,
    required this.index,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final slideAnimation =
    Tween<Offset>(begin: const Offset(0, 0.11), end: Offset.zero).animate(
      CurvedAnimation(
        parent: animation,
        curve: Interval(0.15 * index, 1.0, curve: Curves.easeOut),
      ),
    );

    final fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animation,
        curve: Interval(0.1 * index, 1.0, curve: Curves.easeIn),
      ),
    );

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: DayMenuCard(dayMenu: dayMenu),
      ),
    );
  }
}
