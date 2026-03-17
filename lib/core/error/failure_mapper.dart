import 'package:dio/dio.dart';

import 'package:ManasYemek/core/error/exceptions.dart';
import 'package:ManasYemek/core/error/failures.dart';

Failure mapExceptionToFailure(Object exception) {
  if (exception is DataExpiredException) {
    return DataExpiredFailure(exception.message ?? 'Saved data is too old.');
  }

  if (exception is CacheException) {
    return CacheFailure(exception.message);
  }

  if (exception is DioException || exception is ServerException) {
    return const ServerFailure();
  }

  return const ServerFailure('Unexpected error');
}
