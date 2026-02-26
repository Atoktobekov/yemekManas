import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:ManasYemek/features/menu/domain/entities/menu_item_entity.dart';

class DishDetailsScreen extends StatelessWidget {
  final MenuItemEntity dish;

  const DishDetailsScreen({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(dish.name)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: dish.fullPhotoUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (_, _) => const Center(child: CircularProgressIndicator()),
              errorWidget: (_, _, _) => const Icon(Icons.broken_image, size: 100),
            ),
          ),
        ),
      ),
    );
  }
}
