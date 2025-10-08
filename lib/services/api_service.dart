import 'package:dio/dio.dart';
import 'package:manas_yemek/models/models.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://yemek-api.vercel.app/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
    ),
  );

  static Future<List<DailyMenu>> fetchMenu() async {
    try {
      final response = await _dio.get('/');

      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((e) => DailyMenu.fromJson(e)).toList();
      } else {
        throw Exception('Ошибка загрузки данных: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Превышено время ожидания ответа от сервера');
      } else if (e.type == DioExceptionType.badResponse) {
        throw Exception('Ошибка сервера: ${e.response?.statusCode}');
      } else {
        throw Exception('Не удалось загрузить меню: ${e.message}');
      }
    } catch (e) {
      throw Exception('Неизвестная ошибка: $e');
    }
  }
}
