import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/format_date_service.dart';

class DayCard2 extends StatelessWidget {
  final DailyMenu dayMenu;

  const DayCard2({super.key, required this.dayMenu});

  @override
  Widget build(BuildContext context) {
    final dateText = formatDate(dayMenu.date);
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.9, // почти весь экран
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: Colors.black45,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              // Дата
              Text(
                dateText,
                style: Theme.of(context).textTheme.headlineMedium
              ),
              const SizedBox(height: 15),

              // Список блюд
              Expanded(
                child: ListView.separated(
                  itemCount: dayMenu.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = dayMenu.items[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            item.photoUrl,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 180,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.broken_image, size: 60),
                            ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 180,
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text('${item.caloriesCount} kcal'),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              Padding(
                padding: EdgeInsets.all(8),
                child: // Итоговый калораж
                Text(
                  'Итого: ${dayMenu.items.fold<int>(0, (sum, item) => sum + item.caloriesCount)} kcal',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
