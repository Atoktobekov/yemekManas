import 'package:ManasYemek/features/menu/data/models/remote/menu_response_remote_model.dart';
import 'package:dio/dio.dart';

import 'package:ManasYemek/core/constants/api_constants.dart';

class MenuRemoteDataSource {
  final Dio _dio;

  const MenuRemoteDataSource(this._dio);

  Future<MenuResponseRemoteModel> fetchMenus() async {
    final response = await _dio.get(ApiConstants.menuPath);
    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid menu response format');
    }

    return MenuResponseRemoteModel.fromJson(data);
  }
}