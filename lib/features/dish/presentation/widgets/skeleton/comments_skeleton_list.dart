import 'package:flutter/material.dart';
import 'shimmer_box.dart';

class CommentSkeletonTile extends StatelessWidget {
  const CommentSkeletonTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: double.infinity, height: 13),
          SizedBox(height: 6),
          ShimmerBox(width: 180, height: 13),
          SizedBox(height: 8),
          ShimmerBox(width: 100, height: 11),
        ],
      ),
    );
  }
}

class CommentsSkeletonList extends StatelessWidget {
  const CommentsSkeletonList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
            (_) => const CommentSkeletonTile(),
      ),
    );
  }
}