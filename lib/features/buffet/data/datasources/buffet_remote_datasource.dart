import 'package:ManasYemek/core/constants/api_constants.dart';
import 'package:ManasYemek/core/error/exceptions.dart';
import 'package:ManasYemek/features/buffet/data/models/buffet_menu_model.dart';
import 'package:dio/dio.dart';

class BuffetRemoteDataSource {
  final Dio _dio;

  const BuffetRemoteDataSource(this._dio);

  Future<BuffetMenuModel> fetchMenu() async {
    try {
      final response = await _dio.get(ApiConstants.buffetPath);
      final data = response.data;

      if (data is! Map<String, dynamic>) {
        throw ServerException('Invalid buffet response format');
      }

      return BuffetMenuModel.fromJson(data);
    } on DioException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (_) {
      throw ServerException('Unexpected buffet response');
    }
  }
}
