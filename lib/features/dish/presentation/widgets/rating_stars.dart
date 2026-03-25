import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final ValueChanged<double>? onRatingSelected;
  final bool isLoading;
  final bool isEnabled;

  const RatingStars({
    super.key,
    required this.rating,
    required this.onRatingSelected,
    this.isLoading = false,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading || !isEnabled,
      child: Opacity(
        opacity: isEnabled ? 1 : 0.5,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final starValue = index + 1;
            final icon = _resolveIcon(starValue.toDouble());

            return TweenAnimationBuilder(
              tween: Tween(begin: 1.0, end: rating >= starValue ? 1.2 : 1.0),
              duration: const Duration(milliseconds: 200),
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: IconButton(
                onPressed: () => onRatingSelected?.call(starValue.toDouble()),
                icon: Icon(icon, color: Colors.amber, size: 28),
              ),
            );
          }),
        ),
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
