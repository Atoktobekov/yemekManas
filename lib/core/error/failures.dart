abstract class Failure {
  final String message;

  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error']);
}

class DataExpiredFailure extends Failure {
  const DataExpiredFailure([
    super.message = 'No internet connection and saved data is too old.',
  ]);
}
