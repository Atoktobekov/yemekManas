import 'package:flutter/material.dart';
import 'package:ManasYemek/view_models/menu_view_model.dart';
import 'package:ManasYemek/view/widgets/widgets.dart';

class MenuContent extends StatelessWidget {
  final PageController pageController;
  final MenuViewModel viewModel;
  final Function(DragStartDetails) onDragStart;
  final Function(DragUpdateDetails) onDragUpdate;
  final Function(DragEndDetails) onDragEnd;

  const MenuContent({
    super.key,
    required this.pageController,
    required this.viewModel,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragStart: onDragStart,
      onVerticalDragUpdate: onDragUpdate,
      onVerticalDragEnd: onDragEnd,
      child: PageView.builder(
        controller: pageController,
        itemCount: viewModel.menus.length,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final dayMenu = viewModel.menus[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: DayCard(dayMenu: dayMenu),
          );
        },
      ),
    );
  }
}
