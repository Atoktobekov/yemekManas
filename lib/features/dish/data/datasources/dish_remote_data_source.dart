import 'package:ManasYemek/features/dish/data/models/comment_model.dart';
import 'package:ManasYemek/features/dish/data/models/dish_details_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DishRemoteDataSource {
  Future<DishDetailsModel> getDishDetails(String dishId);

  Stream<List<CommentModel>> watchComments(String dishId);

  Future<void> addComment({required String dishId, required String text});

  Future<double> rateDish({
    required String dishId,
    required double selectedRating,
  });
}

class DishRemoteDataSourceImpl implements DishRemoteDataSource {
  final FirebaseFirestore _firestore;

  DishRemoteDataSourceImpl(this._firestore);

  CollectionReference<Map<String, dynamic>> get _dishesCollection =>
      _firestore.collection('dishes');

  @override
  Future<DishDetailsModel> getDishDetails(String dishId) async {
    final docRef = _dishesCollection.doc(dishId);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      await docRef.set(
        {
          'description': '',
          'rating': FieldValue.increment(0),
          'ratingsCount': FieldValue.increment(0),
        },
        SetOptions(merge: true), // safe from race condition
      );

      return DishDetailsModel(
        id: dishId,
        description: '',
        rating: 0,
        ratingsCount: 0,
      );
    }

    final data = snapshot.data() ?? <String, dynamic>{};
    return DishDetailsModel.fromFirestore(id: snapshot.id, json: data);
  }

  @override
  Stream<List<CommentModel>> watchComments(String dishId) {
    return _dishesCollection
        .doc(dishId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    CommentModel.fromFirestore(id: doc.id, json: doc.data()),
              )
              .toList(growable: false),
        );
  }

  @override
  Future<void> addComment({
    required String dishId,
    required String text,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final dishDoc = _dishesCollection.doc(dishId);

    await dishDoc.set(
      {
        'rating': FieldValue.increment(0),
        'ratingsCount': FieldValue.increment(0),
      },
      SetOptions(merge: true),
    );

    await dishDoc.collection('comments').add({
      'text': trimmed,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
/*  @override
  Future<void> addComment({
    required String dishId,
    required String text,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final dishDoc = _dishesCollection.doc(dishId);
    final snapshot = await dishDoc.get();

    if (!snapshot.exists) {
      await dishDoc.set({
        'description': '',
        'rating': 0,
        'ratingsCount': 0,
      });
    }

    await dishDoc.collection('comments').add({
      'text': trimmed,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }*/

  @override
  Future<double> rateDish({
    required String dishId,
    required double selectedRating,
  }) async {
    final sanitizedRating = selectedRating.clamp(1, 5).toDouble();
    final docRef = _dishesCollection.doc(dishId);

    final newRating = await _firestore.runTransaction<double>((
      transaction,
    ) async {
      final snapshot = await transaction.get(docRef);
      final data = snapshot.data() ?? <String, dynamic>{};

      final currentRating = (data['rating'] as num?)?.toDouble() ?? 0;
      final currentCount = (data['ratingsCount'] as num?)?.toInt() ?? 0;

      final nextCount = currentCount + 1;
      final recalculatedRating =
          ((currentRating * currentCount) + sanitizedRating) / nextCount;

      transaction.set(docRef, {
        'description': (data['description'] as String?) ?? '',
        'rating': recalculatedRating,
        'ratingsCount': nextCount,
      }, SetOptions(merge: true));

      return recalculatedRating;
    });

    return newRating;
  }
}
