class MenuItemEntity {
  final String id;
  final String name;
  final int calories;
  final String thumbUrl;
  final String fullPhotoUrl;

  const MenuItemEntity({
    required this.id,
    required this.name,
    required this.calories,
    required this.thumbUrl,
    required this.fullPhotoUrl,
  });
}