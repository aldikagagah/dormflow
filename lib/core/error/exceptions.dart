/// Custom exceptions untuk DormFlow Mobile
///
/// Exceptions ini digunakan di data layer dan akan di-catch
/// untuk dikonversi menjadi Failure di repository.
library;

/// Exception saat terjadi error dari server/Firebase.
class ServerException implements Exception {

  const ServerException([this.message = 'Server error occurred', this.code]);
  final String message;
  final String? code;

  @override
  String toString() => 'ServerException: $message';
}

/// Exception saat terjadi error cache/local storage.
class CacheException implements Exception {

  const CacheException([this.message = 'Cache error occurred']);
  final String message;

  @override
  String toString() => 'CacheException: $message';
}

/// Exception saat tidak ada koneksi internet.
class NetworkException implements Exception {

  const NetworkException([this.message = 'No internet connection']);
  final String message;

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception saat data tidak ditemukan.
class NotFoundException implements Exception {

  const NotFoundException([this.message = 'Data not found']);
  final String message;

  @override
  String toString() => 'NotFoundException: $message';
}
