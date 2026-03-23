import 'package:ManasYemek/features/dish/domain/entities/comment_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    required super.id,
    required super.text,
    required super.createdAt,
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

  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
