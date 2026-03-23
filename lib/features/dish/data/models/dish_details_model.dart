import 'package:ManasYemek/features/dish/domain/entities/dish_details_entity.dart';

class DishDetailsModel extends DishDetailsEntity {
  const DishDetailsModel({
    required super.id,
    required super.description,
    required super.rating,
    required super.ratingsCount,
  });

  factory DishDetailsModel.fromFirestore({
    required String id,
    required Map<String, dynamic> json,
  }) {
    return DishDetailsModel(
      id: id,
      description: (json['description'] as String?)?.trim() ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      ratingsCount: (json['ratingsCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'description': description,
      'rating': rating,
      'ratingsCount': ratingsCount,
    };
  }
}
