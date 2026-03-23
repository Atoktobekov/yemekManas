import 'package:ManasYemek/features/dish/domain/entities/comment_entity.dart';
import 'package:ManasYemek/features/dish/presentation/providers/dish_provider.dart';
import 'package:ManasYemek/features/dish/presentation/widgets/rating_stars.dart';
import 'package:ManasYemek/features/menu/domain/entities/menu_item_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DishDetailsScreen extends StatelessWidget {
  final MenuItemEntity dish;

  const DishDetailsScreen({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DishProvider.fromGetIt()..loadDish(dish.id),
      child: _DishDetailsView(dish: dish),
    );
  }
}

class _DishDetailsView extends StatefulWidget {
  final MenuItemEntity dish;

  const _DishDetailsView({required this.dish});

  @override
  State<_DishDetailsView> createState() => _DishDetailsViewState();
}

class _DishDetailsViewState extends State<_DishDetailsView> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DishProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(title: Text(widget.dish.name)),
          body: SafeArea(
            child: provider.status == DishStatus.loading && provider.details == null
                ? const Center(child: CircularProgressIndicator())
                : provider.status == DishStatus.error && provider.details == null
                ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  provider.errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            )
                : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _DishHeader(dish: widget.dish),
                      const SizedBox(height: 18),
                      Text(
                        '${widget.dish.calories} kcal',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          RatingStars(
                            rating: provider.details?.rating ?? 0,
                            isLoading: provider.isSubmittingRating,
                            onRatingSelected: provider.rateDish,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(provider.details?.rating ?? 0).toStringAsFixed(1)} (${provider.details?.ratingsCount ?? 0})',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        (provider.details?.description.isNotEmpty ?? false)
                            ? provider.details!.description
                            : 'Описание пока отсутствует.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Комментарии',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      StreamBuilder<List<CommentEntity>>(
                        stream: provider.commentsStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          if (snapshot.hasError) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text('Не удалось загрузить комментарии.'),
                            );
                          }

                          final comments =
                              snapshot.data ?? const <CommentEntity>[];
                          if (comments.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text('Пока нет комментариев. Будьте первым!'),
                            );
                          }

                          return Column(
                            children: comments
                                .map((comment) => _CommentTile(comment: comment))
                                .toList(growable: false),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                _CommentInput(
                  controller: _commentController,
                  isSubmitting: provider.isSubmittingComment,
                  onSend: () async {
                    final text = _commentController.text.trim();
                    if (text.isEmpty) {
                      return;
                    }

                    await provider.addComment(text);
                    if (!mounted) {
                      return;
                    }

                    if (provider.errorMessage.isEmpty) {
                      _commentController.clear();
                      FocusScope.of(context).unfocus();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(provider.errorMessage)),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DishHeader extends StatelessWidget {
  final MenuItemEntity dish;

  const _DishHeader({required this.dish});

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
            placeholder: (_, _) => const SizedBox(
              height: 240,
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (_, _, _) => const SizedBox(
              height: 240,
              child: Center(child: Icon(Icons.broken_image, size: 48)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          dish.name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _CommentTile extends StatelessWidget {
  final CommentEntity comment;

  const _CommentTile({required this.comment});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd.MM.yyyy HH:mm').format(comment.createdAt.toLocal());

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
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isSubmitting;
  final VoidCallback onSend;

  const _CommentInput({
    required this.controller,
    required this.isSubmitting,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE5E5E5))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 3,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: const InputDecoration(
                hintText: 'Написать комментарий...',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: isSubmitting ? null : onSend,
            icon: isSubmitting
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Icon(Icons.send_rounded),
          ),
        ],
      ),
    );
  }
}
