import 'package:ManasYemek/features/dish/domain/entities/comment_entity.dart';
import 'package:ManasYemek/features/dish/presentation/providers/dish_provider.dart';
import 'package:ManasYemek/features/dish/presentation/widgets/comment_input.dart';
import 'package:ManasYemek/features/dish/presentation/widgets/comment_tile.dart';
import 'package:ManasYemek/features/dish/presentation/widgets/dish_header.dart';
import 'package:ManasYemek/features/dish/presentation/widgets/rating_stars.dart';
import 'package:ManasYemek/features/dish/presentation/widgets/skeleton/comments_skeleton_list.dart';
import 'package:ManasYemek/features/dish/presentation/widgets/skeleton/dish_details_skeleton.dart';
import 'package:ManasYemek/features/menu/domain/entities/menu_item_entity.dart';
import 'package:ManasYemek/shared/presentation/screens/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
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

class _DishDetailsViewState extends State<_DishDetailsView>
    with SingleTickerProviderStateMixin {
  final TextEditingController _commentController = TextEditingController();

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  bool _hasAnimatedIn = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _commentController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _triggerFadeInIfNeeded(DishProvider provider) {
    if (!_hasAnimatedIn && provider.details != null) {
      _hasAnimatedIn = true;
      // postFrameCallback гарантирует что виджет уже смонтирован
      // и кадр с opacity=0 успел отрисоваться до старта анимации
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _fadeController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DishProvider>(
      builder: (context, provider, _) {
        _triggerFadeInIfNeeded(provider);

        final isInitialLoading =
            provider.status == DishStatus.loading && provider.details == null;
        final isError =
            provider.status == DishStatus.error && provider.details == null;

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.dish.name),
            leading: const BackButton(),
          ),
          body: SafeArea(
            child: isInitialLoading
                ? const DishDetailsSkeleton()
                : isError
                ? ErrorScreen()
                : FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          DishHeader(dish: widget.dish),
                          const SizedBox(height: 18),
                          Text(
                            '${widget.dish.calories} kcal',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              RatingStars(
                                rating: provider.details?.rating ?? 0,
                                isLoading: provider.isSubmittingRating,
                                isEnabled: !provider.hasRated,
                                onRatingSelected: (rating) {
                                  HapticFeedback.mediumImpact();
                                  provider.rateDish(rating);
                                  _showSuccessDialog(context);
                                },
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${(provider.details?.rating ?? 0).toStringAsFixed(1)} (${provider.details?.ratingsCount ?? 0})',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            (provider.details?.description.isNotEmpty ??
                                false)
                                ? provider.details!.description
                                : 'Описание пока отсутствует.',
                            style:
                            Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Комментарии',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge,
                          ),
                          const SizedBox(height: 10),
                          StreamBuilder<List<CommentEntity>>(
                            stream: provider.commentsStream,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CommentsSkeletonList();
                              }

                              if (snapshot.hasError) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12),
                                  child: Text(
                                    'Не удалось загрузить комментарии.',
                                  ),
                                );
                              }

                              final comments = snapshot.data ??
                                  const <CommentEntity>[];
                              if (comments.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12),
                                  child: Text(
                                    'Пока нет комментариев. Будьте первым!',
                                  ),
                                );
                              }

                              return Column(
                                children: comments
                                    .map((c) => CommentTile(comment: c))
                                    .toList(growable: false),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    CommentInput(
                      controller: _commentController,
                      isSubmitting: provider.isSubmittingComment,
                      onSend: () async {
                        final text = _commentController.text.trim();
                        if (text.isEmpty) return;

                        await provider.addComment(text);
                        if (!mounted) return;

                        if (provider.errorMessage.isEmpty) {
                          _commentController.clear();
                          FocusScope.of(context).unfocus();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                Text(provider.errorMessage)),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ), // SlideTransition
            ),
          ),
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(const Duration(milliseconds: 1420), () {
          if (context.mounted) Navigator.pop(context);
        });

        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/animations/success.json',
                  width: 140,
                  repeat: false,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Спасибо!',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ваша оценка принята 🙌',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}