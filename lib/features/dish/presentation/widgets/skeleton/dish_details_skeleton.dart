import 'package:flutter/material.dart';
import 'shimmer_box.dart';
import 'comments_skeleton_list.dart';

class DishDetailsSkeleton extends StatelessWidget {
  const DishDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(
            width: double.infinity,
            height: 240,
            borderRadius: BorderRadius.circular(16),
          ),
          const SizedBox(height: 12),
          const ShimmerBox(width: 200, height: 22),
          const SizedBox(height: 18),
          const ShimmerBox(width: 60, height: 16),
          const SizedBox(height: 12),
          const ShimmerBox(width: 240, height: 24),
          const SizedBox(height: 16),
          const ShimmerBox(width: double.infinity, height: 14),
          const SizedBox(height: 8),
          const ShimmerBox(width: double.infinity, height: 14),
          const SizedBox(height: 8),
          const ShimmerBox(width: 220, height: 14),
          const SizedBox(height: 24),
          const ShimmerBox(width: 130, height: 20),
          const SizedBox(height: 14),
          const CommentsSkeletonList(),
        ],
      ),
    );
  }
}