import 'package:dio/dio.dart';
import '../models/daily_menu.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://yemek-api.vercel.app/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<DailyMenu>> fetchMenu() async {
    try {
      final response = await _dio.get('/');
      final data = response.data as List;
      return data.map((e) => DailyMenu.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception('Ошибка загрузки данных: ${e.message}');
    }
  }
}
