import 'package:ManasYemek/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ManasYemek/view_models/menu_view_model.dart';

class MenuScreen2 extends StatefulWidget {
  const MenuScreen2({super.key});

  @override
  State<MenuScreen2> createState() => _MenuScreen2State();
}

class _MenuScreen2State extends State<MenuScreen2> {
  @override
  void initState() {
    super.initState();

    final viewModel = context.read<MenuViewModel>();
    if (viewModel.status == MenuStatus.initial) {
      viewModel.fetchMenu();
    }
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
          switch (viewModel.status) {
            case MenuStatus.initial:
            case MenuStatus.loading:
              return const Center(
                child: CircularProgressIndicator(color: Colors.yellow),
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
              return RefreshIndicator(
                onRefresh: () async {
                  await viewModel.fetchMenu();
                },
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  itemCount: viewModel.menus.length,
                  separatorBuilder: (context, index) => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    child: Divider(thickness: 1, color: Colors.grey),
                  ),
                  itemBuilder: (context, index) {
                    return DayMenuWidget(dayMenu: viewModel.menus[index]);
                  },
                ),
              );
          }
        },
      ),
    );
  }
}
