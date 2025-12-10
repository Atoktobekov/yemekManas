import 'package:ManasYemek/exceptions/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:ManasYemek/models/daily_menu.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class ApiService2 {
  Future<List<DailyMenu>> fetchMenu() async {
    try {
      final response = await GetIt.instance<Dio>().get('/');
      final data = response.data;

      if (data is! List) {
        throw Exception('Incorrect Format API: waiting List');
      }

      return data
          .map((e) => DailyMenu.fromJson(e as Map<String, dynamic>?))
          .toList();
    } on DioException catch (e) {
      GetIt.instance<Talker>().handle(e, null, '[DioException in ApiService]');
      throw NetworkException(message: "Data fetching error");
    } catch (e) {
      GetIt.instance<Talker>().handle(e);
      rethrow;
    }
  }
}
