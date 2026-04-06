import 'package:ManasYemek/features/buffet/domain/entities/buffet_category_entity.dart';
import 'package:flutter/material.dart';

class BuffetHeader extends StatelessWidget {
  final List<BuffetCategoryEntity> categories;
  final String activeCategoryId;
  final ScrollController categoryScrollController;
  final Map<String, GlobalKey> categoryButtonKeys;
  final ValueChanged<String> onCategoryTap;

  const BuffetHeader({
    super.key,
    required this.categories,
    required this.activeCategoryId,
    required this.categoryScrollController,
    required this.categoryButtonKeys,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surface,
      child: Column(
        children: [
          const SizedBox(height: 8),
          SizedBox(
            height: 32,
            child: ListView.builder(
              controller: categoryScrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isActive = cat.id == activeCategoryId;
                return GestureDetector(
                  onTap: () => onCategoryTap(cat.id),
                  child: Container(
                    key: categoryButtonKeys[cat.id],
                    margin: const EdgeInsets.only(right: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isActive ? colorScheme.primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      cat.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive ? colorScheme.onSurface : colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1, thickness: 1, color: colorScheme.outline.withOpacity(0.2)),
        ],
      ),
    );
  }
}
