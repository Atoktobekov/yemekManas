import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/menu_view_model.dart';
import 'widgets/day_card2.dart';

class MenuScreen2 extends StatefulWidget {
  const MenuScreen2({super.key});

  @override
  State<MenuScreen2> createState() => _MenuScreen2State();
}

class _MenuScreen2State extends State<MenuScreen2> {
  late PageController _pageController;
  double _dragStartY = 0.0;
  double _dragCurrentY = 0.0;
  bool _isAnimating = false;

  // Параметры — можно подогнать
  static const double edgeZone = 100.0; // от краёв экрана где свайп разрешён
  static const double distanceThreshold = 120.0; // минимальная дистанция для перелиста
  static const double velocityThreshold = 700.0; // минимальная скорость для перелиста

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

  void _onDragStart(DragStartDetails details) {
    _dragStartY = details.globalPosition.dy;
    _dragCurrentY = _dragStartY;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _dragCurrentY = details.globalPosition.dy;
  }

  void _onDragEnd(DragEndDetails details) {
    if (_isAnimating) return;

    final viewModel = context.read<MenuViewModel>();
    final pageCount = viewModel.menus.length;
    final height = MediaQuery.of(context).size.height;
    final delta = _dragCurrentY - _dragStartY; // положительное = движение вниз
    final vy = details.velocity.pixelsPerSecond.dy; // положительное = вниз
    final currentPageDouble = _pageController.page ?? _pageController.initialPage.toDouble();
    final currentPage = currentPageDouble; // double

    int targetPage = currentPageDouble.round();

    // Разрешаем перелистывать только если свайп начат из краевой зоны (верх/низ)
    final startedAtTopEdge = _dragStartY < edgeZone;
    final startedAtBottomEdge = _dragStartY > height - edgeZone;

    // Если скорость большая — используем направление скорости
    if (vy.abs() > velocityThreshold) {
      if (vy > 0) {
        // двигаемся вниз — хотим предыдущий день (index -1)
        targetPage = (currentPage).floor() - 1;
      } else {
        // двигаемся вверх — хотим следующий день
        targetPage = (currentPage).ceil() + 1;
      }
    } else {
      // иначе используем дистанцию и краевую зону
      if (delta > distanceThreshold && startedAtTopEdge) {
        // тянем вниз от верхнего края — предыдущий день
        targetPage = (currentPage).floor() - 1;
      } else if (delta < -distanceThreshold && startedAtBottomEdge) {
        // тянем вверх от нижнего края — следующий день
        targetPage = (currentPage).ceil() + 1;
      } else {
        // слишком мелкий свайп — остаёмся на той же странице
        targetPage = currentPage.round();
      }
    }

    // Clamp
    final clamped = targetPage.clamp(0, pageCount - 1);

    if (clamped != currentPage.round()) {
      _animateToPage(clamped);
    }
  }

  Future<void> _animateToPage(int page) async {
    _isAnimating = true;
    try {
      await _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    } finally {
      _isAnimating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MenuViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yemek Menüsü'),
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
        elevation: 4,
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
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onVerticalDragStart: _onDragStart,
                onVerticalDragUpdate: _onDragUpdate,
                onVerticalDragEnd: _onDragEnd,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: viewModel.menus.length,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final dayMenu = viewModel.menus[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: DayCard2(dayMenu: dayMenu),
                    );
                  },
                ),
              );
          }
        },
      ),
    );
  }
}
