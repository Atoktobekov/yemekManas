import 'package:flutter/material.dart';
import 'package:manas_yemek/models/models.dart';
import '../services/api_service.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late Future<List<DailyMenu>> _menuFuture;

  @override
  void initState() {
    super.initState();
    _menuFuture = ApiService.fetchMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yemek Menüsü"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<DailyMenu>>(
        future: _menuFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Ошибка: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Меню недоступно"));
          }

          final menu = snapshot.data!;
          return ListView.builder(
            itemCount: menu.length,
            itemBuilder: (context, index) {
              final dayMenu = menu[index];

              return ExpansionTile(
                title: Text(
                  dayMenu.date,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                children: dayMenu.items.map((item) {
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.photoUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(item.name),
                    subtitle: Text("${item.caloriesCount} kcal"),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
