import 'package:ManasYemek/core/error/failure_mapper.dart';
import 'package:ManasYemek/core/error/failures.dart';
import 'package:ManasYemek/features/buffet/domain/entities/buffet_menu_entity.dart';
import 'package:ManasYemek/features/buffet/domain/repositories/buffet_repository.dart';
import 'package:ManasYemek/features/buffet/data/datasources/buffet_remote_datasource.dart';
import 'package:dartz/dartz.dart';

class BuffetRepositoryImpl implements BuffetRepository {
  final BuffetRemoteDataSource _dataSource;

  const BuffetRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, BuffetMenuEntity>> getMenu() async {
    try {
      final menuModel = await _dataSource.fetchMenu();
      return Right(menuModel.toEntity());
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
