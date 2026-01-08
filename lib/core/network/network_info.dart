/// Network info untuk cek konektivitas
library;

import 'package:connectivity_plus/connectivity_plus.dart';

/// Interface untuk mengecek status koneksi jaringan.
abstract class NetworkInfo {
  /// Cek apakah device terhubung ke internet.
  Future<bool> get isConnected;

  /// Stream perubahan status koneksi.
  Stream<bool> get onConnectivityChanged;
}

/// Implementasi NetworkInfo menggunakan connectivity_plus.
class NetworkInfoImpl implements NetworkInfo {

  NetworkInfoImpl([Connectivity? connectivity])
      : _connectivity = connectivity ?? Connectivity();
  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return _isConnectedFromResult(result);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_isConnectedFromResult);
  }

  bool _isConnectedFromResult(List<ConnectivityResult> result) {
    return result.any((r) =>
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.ethernet);
  }
}
