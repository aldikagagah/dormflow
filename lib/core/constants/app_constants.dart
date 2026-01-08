/// App-wide constants untuk DormFlow Mobile
///
/// Semua magic numbers dan strings dikumpulkan di sini
/// agar mudah di-maintain dan di-configure.
library;

/// Konstanta umum aplikasi.
class AppConstants {
  AppConstants._();

  // ============ APP INFO ============
  static const String appName = 'DormFlow';
  static const String appVersion = '1.0.0';

  // ============ ATTENDANCE ============
  /// Jam batas terlambat (default: 09:00)
  static const int lateThresholdHour = 9;
  static const int lateThresholdMinute = 0;

  /// Maksimum riwayat absensi yang ditampilkan
  static const int maxAttendanceHistoryItems = 20;

  /// Cooldown antara absen (dalam detik)
  static const int attendanceCooldownSeconds = 10;

  // ============ FINANCE ============
  static const String currencySymbol = 'Rp';
  static const String currencyLocale = 'id_ID';

  // ============ VALIDATION ============
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;

  // ============ UI ============
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration animationDurationFast = Duration(milliseconds: 150);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);
  static const Duration splashDuration = Duration(seconds: 2);

  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 24.0;

  // ============ PAGINATION ============
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // ============ TIMEOUTS ============
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

/// Collection names di Firestore.
class FirestoreCollections {
  FirestoreCollections._();

  static const String users = 'users';
  static const String attendance = 'attendance';
  static const String transactions = 'transactions';
  static const String schedules = 'schedules';
}

/// Field names untuk Firestore documents.
class FirestoreFields {
  FirestoreFields._();

  // Common
  static const String id = 'id';
  static const String userId = 'userId';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
  static const String timestamp = 'timestamp';

  // User
  static const String email = 'email';
  static const String name = 'name';
  static const String phone = 'phone';
  static const String address = 'address';
  static const String photoUrl = 'photoUrl';
  static const String role = 'role';

  // Attendance
  static const String type = 'type';
  static const String date = 'date';
  static const String status = 'status';
  static const String localTime = 'localTime';

  // Transaction
  static const String category = 'category';
  static const String amount = 'amount';
  static const String description = 'description';
  static const String monthYear = 'monthYear';

  // Schedule
  static const String taskName = 'taskName';
  static const String assignedMemberId = 'assignedMemberId';
  static const String assignedMemberName = 'assignedMemberName';
  static const String dateString = 'dateString';
  static const String weekNumber = 'weekNumber';
  static const String createdBy = 'createdBy';
}

/// Status values yang digunakan di aplikasi.
class StatusValues {
  StatusValues._();

  // Attendance
  static const String hadir = 'Hadir';
  static const String terlambat = 'Terlambat';
  static const String selesai = 'Selesai';
  static const String belumAbsen = 'Belum Absen';

  // Attendance Type
  static const String masuk = 'Masuk';
  static const String keluar = 'Keluar';

  // Transaction Type
  static const String pemasukan = 'Pemasukan';
  static const String pengeluaran = 'Pengeluaran';

  // Schedule
  static const String pending = 'Pending';
  static const String completed = 'Selesai';
}
