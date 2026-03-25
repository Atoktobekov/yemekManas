import 'package:ManasYemek/features/dish/domain/entities/comment_entity.dart';
import 'package:ManasYemek/features/dish/domain/entities/dish_details_entity.dart';
import 'package:ManasYemek/features/dish/domain/usecases/add_comment.dart';
import 'package:ManasYemek/features/dish/domain/usecases/get_comments.dart';
import 'package:ManasYemek/features/dish/domain/usecases/get_dish_details.dart';
import 'package:ManasYemek/features/dish/domain/usecases/rate_dish.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

enum DishStatus { initial, loading, loaded, error }

class DishProvider extends ChangeNotifier {
  final GetDishDetails _getDishDetails;
  final GetComments _getComments;
  final AddComment _addComment;
  final RateDish _rateDish;
  final Talker _talker;

  DishProvider({
    required GetDishDetails getDishDetails,
    required GetComments getComments,
    required AddComment addComment,
    required RateDish rateDish,
    required Talker talker,
  }) : _getDishDetails = getDishDetails,
       _getComments = getComments,
       _addComment = addComment,
       _rateDish = rateDish,
       _talker = talker;

  factory DishProvider.fromGetIt() {
    final getIt = GetIt.instance;
    return DishProvider(
      getDishDetails: getIt<GetDishDetails>(),
      getComments: getIt<GetComments>(),
      addComment: getIt<AddComment>(),
      rateDish: getIt<RateDish>(),
      talker: getIt<Talker>(),
    );
  }

  DishStatus _status = DishStatus.initial;
  DishDetailsEntity? _details;
  String _errorMessage = '';
  bool _isSubmittingComment = false;
  bool _isSubmittingRating = false;
  String _dishId = '';

  DishStatus get status => _status;

  DishDetailsEntity? get details => _details;

  String get errorMessage => _errorMessage;

  bool get isSubmittingComment => _isSubmittingComment;

  bool get isSubmittingRating => _isSubmittingRating;

  bool _hasRated = false;
  bool get hasRated => _hasRated;

  Stream<List<CommentEntity>> get commentsStream => _dishId.isEmpty
      ? const Stream<List<CommentEntity>>.empty()
      : _getComments(_dishId);

  Future<void> loadDish(String dishId) async {
    if (_dishId == dishId && _status == DishStatus.loaded) {
      return;
    }

    _dishId = dishId;
    _status = DishStatus.loading;
    _errorMessage = '';
    notifyListeners();

    final result = await _getDishDetails(dishId);
    result.fold(
      (failure) {
        _status = DishStatus.error;
        _errorMessage = failure.message;
        _talker.error(
          '[DishProvider] failed to load dish $dishId: ${failure.message}',
        );
      },
      (dishDetails) {
        _details = dishDetails;
        _status = DishStatus.loaded;
      },
    );

    notifyListeners();
  }

  Future<void> addComment(String text) async {
    final trimmedText = text.trim();

    // length validation
    if (trimmedText.length > 200) {
      _errorMessage = 'Комментарий слишком длинный (макс. 200 символов)';
      notifyListeners();
      return;
    }

    /// basic filtering
    final forbiddenWords = ['мат1', 'мат2', 'плохоеслово'];
    if (forbiddenWords.any((word) => trimmedText.toLowerCase().contains(word))) {
      _errorMessage = 'Комментарий содержит недопустимые выражения';
      notifyListeners();
      return;
    }

    if (_dishId.isEmpty || trimmedText.isEmpty || _isSubmittingComment) {
      return;
    }

    _isSubmittingComment = true;
    notifyListeners();

    final result = await _addComment(dishId: _dishId, text: trimmedText);
    result.fold(
          (failure) {
        _talker.error('[DishProvider] failed to add comment: ${failure.message}');
        _errorMessage = failure.message;
      },
          (_) {
        _errorMessage = '';
      },
    );

    _isSubmittingComment = false;
    notifyListeners();
  }

  ///Rating dish
  Future<void> rateDish(double selectedRating) async {
    if (_dishId.isEmpty || _isSubmittingRating || _hasRated) {
      return;
    }

    _isSubmittingRating = true;

    // immediate UI update
    if (_details != null) {
      _details = DishDetailsEntity(
        id: _details!.id,
        description: _details!.description,
        rating: selectedRating,
        ratingsCount: _details!.ratingsCount + 1,
      );
    }

    _hasRated = true;
    _errorMessage = '';
    notifyListeners();

    // background sending
    final result = await _rateDish(
      dishId: _dishId,
      selectedRating: selectedRating,
    );

    result.fold(
          (failure) {
        _talker.error('[DishProvider] failed to rate dish $_dishId: ${failure.message}');
        _errorMessage = failure.message;

        _hasRated = false;
      },
          (newRating) {
        //actual rating from server
        if (_details != null) {
          _details = DishDetailsEntity(
            id: _details!.id,
            description: _details!.description,
            rating: newRating,
            ratingsCount: _details!.ratingsCount,
          );
        }
      },
    );

    _isSubmittingRating = false;
    notifyListeners();
  }
}
