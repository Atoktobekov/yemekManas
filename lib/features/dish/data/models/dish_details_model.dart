import 'package:ManasYemek/features/dish/domain/entities/dish_details_entity.dart';

class DishDetailsModel {
  final String id;
  final String description;
  final double rating;
  final int ratingsCount;

  const DishDetailsModel({
    required this.id,
    required this.description,
    required this.rating,
    required this.ratingsCount,
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

  DishDetailsEntity toEntity() {
    return DishDetailsEntity(
      id: id,
      description: description,
      rating: rating,
      ratingsCount: ratingsCount,
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
