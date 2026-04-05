import 'package:ManasYemek/features/dish/domain/entities/comment_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String text;
  final DateTime createdAt;

  const CommentModel({
    required this.id,
    required this.text,
    required this.createdAt,
  });

  factory CommentModel.fromFirestore({
    required String id,
    required Map<String, dynamic> json,
  }) {
    final timestamp = json['createdAt'] as Timestamp?;

    return CommentModel(
      id: id,
      text: (json['text'] as String?)?.trim() ?? '',
      createdAt: timestamp?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  CommentEntity toEntity() {
    return CommentEntity(
      id: id,
      text: text,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
