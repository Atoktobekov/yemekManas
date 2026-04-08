import 'package:get_it/get_it.dart';

import 'package:ManasYemek/core/di/modules/core_dependencies.dart';
import 'package:ManasYemek/features/buffet/di/buffet_dependencies.dart';
import 'package:ManasYemek/features/dish/di/dish_dependencies.dart';
import 'package:ManasYemek/features/menu/di/menu_dependencies.dart';
import 'package:ManasYemek/features/update/di/update_dependencies.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  await setupCoreDependencies(getIt);

  setupMenuDependencies(getIt);
  setupDishDependencies(getIt);
  setupUpdateDependencies(getIt);
  setupBuffetDependencies(getIt);
}
