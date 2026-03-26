import 'package:ManasYemek/features/dish/domain/entities/comment_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentTile extends StatelessWidget {
  final CommentEntity comment;

  const CommentTile({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
    DateFormat('dd.MM.yyyy HH:mm').format(comment.createdAt.toLocal());

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(comment.text, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 6),
          Text(
            formattedDate,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}