import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/menu_view_model.dart';
import 'widgets/day_card.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MenuViewModel>(context);

    // Запускаем загрузку один раз после построения виджета
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.status == MenuStatus.initial) {
        viewModel.fetchMenu();
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Yemek Menüsü')),
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
                        style: const TextStyle(fontSize: 16, color: Colors.redAccent),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => viewModel.fetchMenu(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                        ),
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                ),
              );

            case MenuStatus.loaded:
              return RefreshIndicator(
                onRefresh: viewModel.fetchMenu,
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: viewModel.menus.length,
                  itemBuilder: (context, index) {
                    final dayMenu = viewModel.menus[index];
                    return DayCard(dayMenu: dayMenu);
                  },
                ),
              );
          }
        },
      ),
    );
  }
}
