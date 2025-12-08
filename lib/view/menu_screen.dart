import 'package:ManasYemek/repositories/menu_repository.dart';
import 'package:ManasYemek/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:ManasYemek/view_models/menu_view_model.dart';

const message = "No internet connection, showing last data";

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<MenuViewModel>();
      if (viewModel.status == MenuStatus.initial) {
        viewModel.fetchMenu();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MenuViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Yemekhane Menu',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Builder(
        builder: (context) {
          if (viewModel.status == MenuStatus.loaded) {
            _fadeController.forward();
          } else {
            _fadeController.reset();
          }
          switch (viewModel.status) {
            case MenuStatus.initial:
            case MenuStatus.loading:
              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                itemCount: 3,
                separatorBuilder: (_, __) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  child: Divider(thickness: 1, color: Colors.grey),
                ),
                itemBuilder: (_, __) => const DayMenuSkeleton(),
              );

            case MenuStatus.error:
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        viewModel.errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.redAccent,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFAEEDD),
                          foregroundColor: Colors.black,
                        ),
                        onPressed: viewModel.fetchMenu,
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
              );

            case MenuStatus.loaded:
              _fadeController.forward();
              return RefreshIndicator(
                onRefresh: () async {
                  _fadeController.reset();
                  await viewModel.fetchMenu();
                },
                child: Column(
                  children: [
                    if (GetIt.instance<MenuRepository>().isDataFromCache())
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          left: 12.0,
                          right: 6.0,
                        ),
                        child: Text(
                          message,
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 20,
                        ),
                        itemCount: viewModel.menus.length,
                        separatorBuilder: (context, index) => const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 32,
                          ),
                          child: Divider(thickness: 1, color: Colors.grey),
                        ),
                        itemBuilder: (context, index) {
                          return StaggeredDayMenuWidget(
                            dayMenu: viewModel.menus[index],
                            index: index,
                            animation: _fadeAnimation,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
