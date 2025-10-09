import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../models/menu_item.dart';

class MenuItemTile extends StatelessWidget {
  final MenuItem item;
  final VoidCallback? onTap;

  const MenuItemTile({required this.item, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      leading: _buildImage(item.photoUrl),
      title: Text(
        item.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text('${item.caloriesCount} kcal'),
      trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary),
      onTap: onTap,
    );
  }

  Widget _buildImage(String? url) {
    const size = 60.0;
    final borderRadius = BorderRadius.circular(8);

    if (url == null || url.isEmpty) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: SizedBox(
          width: size,
          height: size,
          child: const Center(child: Icon(Icons.fastfood, size: 28)),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (_, __) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(borderRadius: borderRadius, color: Colors.grey.shade200),
        child: const Center(child: Icon(Icons.fastfood)),
      ),
      errorWidget: (_, __, ___) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(borderRadius: borderRadius, color: Colors.grey.shade200),
        child: const Center(child: Icon(Icons.broken_image)),
      ),
    );
  }
}
