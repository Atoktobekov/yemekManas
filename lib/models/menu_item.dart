class MenuItem {
  final String name;
  final int caloriesCount;
  final String photoUrl;

  MenuItem({
    required this.name,
    required this.caloriesCount,
    required this.photoUrl,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'],
      caloriesCount: json['calories_count'],
      photoUrl: json['photo_url'],
    );
  }
}


