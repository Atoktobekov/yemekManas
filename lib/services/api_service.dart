import 'package:dio/dio.dart';
import '../models/daily_menu.dart';
import 'package:flutter/foundation.dart'; // для debugPrint

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://yemek-api.vercel.app/',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  Future<List<DailyMenu>> fetchMenu() async {
    try {
      final response = await _dio.get('/');
      final data = response.data;

      if (data is! List) {
        throw Exception('Неверный формат API: ожидается List');
      }

      return data
          .map((e) => DailyMenu.fromJson(e as Map<String, dynamic>?))
          .toList();
    } on DioException catch (e) {
      debugPrint('DioException: ${e.response?.data ?? e.message}');
      throw Exception('Ошибка загрузки данных: ${e.message}');
    } catch (e) {
      debugPrint('Unknown error: $e');
      rethrow;
    }
  }
}
