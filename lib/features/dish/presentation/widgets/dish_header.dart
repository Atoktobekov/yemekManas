import 'package:ManasYemek/features/menu/domain/entities/menu_item_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'skeleton/shimmer_box.dart';

class DishHeader extends StatelessWidget {
  final MenuItemEntity dish;

  const DishHeader({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedNetworkImage(
            imageUrl: dish.fullPhotoUrl,
            height: 240,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (_, __) => ShimmerBox(
              width: double.infinity,
              height: 240,
              borderRadius: BorderRadius.circular(16),
            ),
            errorWidget: (_, __, ___) => const SizedBox(
              height: 240,
              child: Center(child: Icon(Icons.broken_image, size: 48)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          dish.name,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}