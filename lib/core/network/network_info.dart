import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkInfo {
  final InternetConnection _internetConnection;

  NetworkInfo({InternetConnection? internetConnection})
      : _internetConnection = internetConnection ?? InternetConnection();

  Future<bool> get isConnected => _internetConnection.hasInternetAccess;
}
