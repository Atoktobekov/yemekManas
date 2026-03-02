import 'package:ManasYemek/features/menu/domain/entities/daily_menu_entity.dart';

class MenuEntity{
  List<DailyMenuEntity> days;
  String fetchedAt;

  MenuEntity({required this.days, required this.fetchedAt});
}
