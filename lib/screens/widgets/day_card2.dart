import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/format_date_service.dart';

class DayCard2 extends StatefulWidget {
  final DailyMenu dayMenu;

  const DayCard2({super.key, required this.dayMenu});

  @override
  State<DayCard2> createState() => _DayCard2State();
}

class _DayCard2State extends State<DayCard2> {
  late List<int> _reloadKeys;

  @override
  void initState() {
    super.initState();
    _reloadKeys = List<int>.filled(widget.dayMenu.items.length, 0);
  }

  void _reloadImage(int index) {
    setState(() {
      _reloadKeys[index]++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateText = formatDate(widget.dayMenu.date);
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.9,
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
              const SizedBox(height: 8),
              Text(dateText, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.separated(
                  itemCount: widget.dayMenu.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = widget.dayMenu.items[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            item.photoUrl,
                            key: ValueKey('${item.photoUrl}_${_reloadKeys[index]}'),
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 180,
                              color: Colors.grey.shade300,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.broken_image, size: 60),
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () => _reloadImage(index),
                                    child: const Text('Повторить загрузку'),
                                  ),
                                ],
                              ),
                            ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 180,
                                color: Colors.grey.shade200,
                                child: const Center(child: CircularProgressIndicator()),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Text('${item.caloriesCount} kcal'),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Toplam: ${widget.dayMenu.items.fold<int>(0, (sum, item) => sum + item.caloriesCount)} kcal',
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
