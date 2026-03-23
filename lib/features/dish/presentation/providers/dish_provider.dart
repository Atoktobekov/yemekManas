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
    result.fold((failure) {
      _status = DishStatus.error;
      _errorMessage = failure.message;
      _talker.error('[DishProvider] failed to load dish $dishId: ${failure.message}');
    }, (dishDetails) {
      _details = dishDetails;
      _status = DishStatus.loaded;
    });

    notifyListeners();
  }

  Future<void> addComment(String text) async {
    if (_dishId.isEmpty || text.trim().isEmpty || _isSubmittingComment) {
      return;
    }

    _isSubmittingComment = true;
    notifyListeners();

    final result = await _addComment(dishId: _dishId, text: text);
    result.fold((failure) {
      _talker.error('[DishProvider] failed to add comment: ${failure.message}');
      _errorMessage = failure.message;
    }, (_) {
      _errorMessage = '';
    });

    _isSubmittingComment = false;
    notifyListeners();
  }

  Future<void> rateDish(double selectedRating) async {
    if (_dishId.isEmpty || _isSubmittingRating) {
      return;
    }

    _isSubmittingRating = true;
    notifyListeners();

    final result = await _rateDish(dishId: _dishId, selectedRating: selectedRating);
    result.fold((failure) {
      _talker.error('[DishProvider] failed to rate dish $_dishId: ${failure.message}');
      _errorMessage = failure.message;
    }, (newRating) {
      if (_details != null) {
        _details = DishDetailsEntity(
          id: _details!.id,
          description: _details!.description,
          rating: newRating,
          ratingsCount: _details!.ratingsCount + 1,
        );
      }
      _errorMessage = '';
    });

    _isSubmittingRating = false;
    notifyListeners();
  }
}
