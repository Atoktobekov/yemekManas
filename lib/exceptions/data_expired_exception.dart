class DataExpiredException implements Exception{
  final String? message;

  DataExpiredException({this.message});


  @override
  String toString() => 'DataExpiredException: $message';
}