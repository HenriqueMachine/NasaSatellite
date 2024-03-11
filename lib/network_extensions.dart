import 'package:connectivity_plus/connectivity_plus.dart';

extension ConnectivityExtension on ConnectivityResult {
  bool get isConnected {
    return this != ConnectivityResult.none;
  }
}
