class ServerException implements Exception {
  final String message;

  ServerException([this.message = 'Server error']);
}

class CacheException implements Exception {
  final String message;

  CacheException([this.message = 'Cache error']);
}

class DataExpiredException implements Exception{
  final String? message;

  DataExpiredException({this.message});


  @override
  String toString() => 'DataExpiredException: $message';
}

class ApkNotFoundException implements Exception {
  final String message = "APK not found in archive!";
}
