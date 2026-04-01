import 'package:ManasYemek/features/buffet/domain/entities/buffet_menu_entity.dart';
import 'package:ManasYemek/features/buffet/domain/repositories/buffet_repository.dart';
import 'package:ManasYemek/features/buffet/data/datasources/buffet_remote_datasource.dart';

class BuffetRepositoryImpl implements BuffetRepository {
  final BuffetRemoteDataSource _dataSource;

  const BuffetRepositoryImpl(this._dataSource);

  @override
  Future<BuffetMenuEntity> getMenu() => _dataSource.fetchMenu();
}