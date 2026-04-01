import 'package:ManasYemek/core/constants/api_constants.dart';
import 'package:ManasYemek/features/buffet/data/models/buffet_menu_model.dart';
import 'package:ManasYemek/features/buffet/domain/entities/buffet_menu_entity.dart';
import 'package:dio/dio.dart';

class BuffetRemoteDataSource {
  final Dio _dio;

  const BuffetRemoteDataSource(this._dio);

  Future<BuffetMenuEntity> fetchMenu() async {
    final response = await _dio.get(ApiConstants.buffetPath);
    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid buffet response format');
    }

    return BuffetMenuModel.fromJson(data);
  }
}