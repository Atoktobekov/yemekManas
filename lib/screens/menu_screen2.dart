import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ManasYemek/view_models/menu_view_model.dart';
import 'widgets/menu_content.dart';
import 'widgets/vertical_swipe_mixin.dart';

class MenuScreen2 extends StatefulWidget {
  const MenuScreen2({super.key});

  @override
  State<MenuScreen2> createState() => _MenuScreen2State();
}

class _MenuScreen2State extends State<MenuScreen2>
    with VerticalPageSwipeHandler {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<MenuViewModel>();
      if (viewModel.status == MenuStatus.initial) {
        viewModel.fetchMenu();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleDragEnd(DragEndDetails details) async {
    final viewModel = context.read<MenuViewModel>();
    final currentPage = _pageController.page?.round() ?? 0;
    final target = onDragEnd(details, currentPage, viewModel.menus.length, context);

    if (target != null && target != currentPage) {
      await animateToPage(_pageController, target);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MenuViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yemek Menüsü'),
      ),
      body: Builder(
        builder: (context) {
          switch (viewModel.status) {
            case MenuStatus.initial:
            case MenuStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case MenuStatus.error:
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ошибка загрузки данных\n${viewModel.errorMessage}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.redAccent,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: viewModel.fetchMenu,
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                ),
              );

            case MenuStatus.loaded:
              return MenuContent(
                pageController: _pageController,
                viewModel: viewModel,
                onDragStart: onDragStart,
                onDragUpdate: onDragUpdate,
                onDragEnd: _handleDragEnd,
              );
          }
        },
      ),
    );
  }
}
