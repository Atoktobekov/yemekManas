class MenuItem {
  final String name;
  final int caloriesCount;
  final String photoUrl;

  MenuItem({
    required this.name,
    required this.caloriesCount,
    required this.photoUrl,
  });

  factory MenuItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return MenuItem(name: '', caloriesCount: 0, photoUrl: '');
    }

    final name = json['name']?.toString() ?? '';
    final caloriesCount = (json['calories_count'] is int)
        ? json['calories_count'] as int
        : int.tryParse(json['calories_count']?.toString() ?? '') ?? 0;
    final photoUrl = json['photo_url']?.toString() ?? '';

    return MenuItem(
      name: name,
      caloriesCount: caloriesCount,
      photoUrl: photoUrl,
    );
  }
}
