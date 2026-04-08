import 'package:flutter/material.dart';

class MenuItemSkeleton extends StatelessWidget {
  final Color baseColor;

  const MenuItemSkeleton({
    super.key,
    required this.baseColor,
  });

  @override
  Widget build(BuildContext context) {
    final containerColor = Theme.of(context).colorScheme.surfaceContainer;

    return Container(
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            height: 105,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: double.infinity,
                    color: baseColor,
                  ),
                  const SizedBox(height: 8),
                  Container(height: 14, width: 70, color: baseColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}