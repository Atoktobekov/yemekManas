class CommentEntity {
  final String id;
  final String text;
  final DateTime createdAt;

  const CommentEntity({
    required this.id,
    required this.text,
    required this.createdAt,
  });
}
