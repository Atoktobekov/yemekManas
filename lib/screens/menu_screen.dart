import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/menu_view_model.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MenuViewModel>(context);

    // Вызываем fetchMenu один раз после построения виджета
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.status == MenuStatus.initial) {
        viewModel.fetchMenu();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yemek Menüsü'),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Builder(
        builder: (context) {
          switch (viewModel.status) {
            case MenuStatus.initial:
            case MenuStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case MenuStatus.error:
              return Center(
                child: Text(
                  'Ошибка загрузки данных\n${viewModel.errorMessage}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.redAccent),
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
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      shadowColor: Colors.black45,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dayMenu.date,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Column(
                              children: dayMenu.items.map((item) {
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 0),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: item.photoUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Container(
                                            color: Colors.grey.shade200,
                                            width: 60,
                                            height: 60,
                                            child: const Icon(
                                              Icons.fastfood,
                                              color: Colors.grey,
                                            ),
                                          ),
                                      errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                    ),
                                  ),
                                  title: Text(
                                    item.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text('${item.caloriesCount} kcal'),
                                  trailing: const Icon(
                                    Icons.chevron_right,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                  onTap: () {},
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
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
