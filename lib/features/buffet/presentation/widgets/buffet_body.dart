import 'package:ManasYemek/features/buffet/domain/entities/buffet_category_entity.dart';
import 'package:ManasYemek/features/buffet/presentation/widgets/buffet_menu_item_card.dart';
import 'package:flutter/material.dart';

class BuffetBody extends StatelessWidget {
  final ScrollController scrollController;
  final List<BuffetCategoryEntity> categories;
  final Map<String, GlobalKey> sectionKeys;
  final String currency;

  const BuffetBody({
    super.key,
    required this.scrollController,
    required this.categories,
    required this.sectionKeys,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        children: categories.map((category) {
          return Container(
            key: sectionKeys[category.id],
            margin: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    category.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                GridView.builder(
                  itemCount: category.items.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 205,
                  ),
                  itemBuilder: (context, index) {
                    return BuffetMenuItemCard(
                      item: category.items[index],
                      currency: currency,
                    );
                  },
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
