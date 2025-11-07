import 'package:ManasYemek/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ManasYemek/view_models/menu_view_model.dart';
import 'widgets/widgets.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
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
    final target =
    onDragEnd(details, currentPage, viewModel.menus.length, context);

    if (target != null && target != currentPage) {
      await animateToPage(_pageController, target);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MenuViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: cremeColor,
      appBar: AppBar(
        title: const Text(
          'Yemek Menüsü',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: softOrange,
        elevation: 3,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Builder(
        builder: (context) {
          switch (viewModel.status) {
            case MenuStatus.initial:
            case MenuStatus.loading:
              return const Center(
                child: CircularProgressIndicator(color: secondAccent),
              );

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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: softOrange,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: viewModel.fetchMenu,
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                ),
              );

            case MenuStatus.loaded:
              return Container(
                color: cremeColor,
                child: MenuContent(
                  pageController: _pageController,
                  viewModel: viewModel,
                  onDragStart: onDragStart,
                  onDragUpdate: onDragUpdate,
                  onDragEnd: _handleDragEnd,
                ),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: secondAccent,
        foregroundColor: Colors.white,
        onPressed: viewModel.fetchMenu,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
