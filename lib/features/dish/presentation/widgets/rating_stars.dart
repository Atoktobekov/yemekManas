import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onRatingSelected;
  final bool isLoading;

  const RatingStars({
    super.key,
    required this.rating,
    required this.onRatingSelected,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) {
          final starValue = index + 1;
          final icon = _resolveIcon(starValue.toDouble());

          return IconButton(
            onPressed: () => onRatingSelected(starValue.toDouble()),
            visualDensity: VisualDensity.compact,
            icon: Icon(icon, color: Colors.amber, size: 28),
          );
        }),
      ),
    );
  }

  IconData _resolveIcon(double starValue) {
    if (rating >= starValue) {
      return Icons.star_rounded;
    }

    if (rating >= starValue - 0.5) {
      return Icons.star_half_rounded;
    }

    return Icons.star_border_rounded;
  }
}
