/// Attendance Repository Interface
library;

import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../data/models/attendance_model.dart';

/// Interface repository untuk absensi.
abstract class AttendanceRepository {
  /// Mencatat absensi (masuk/keluar).
  ///
  /// [type] harus 'Masuk' atau 'Keluar'
  Future<Either<Failure, AttendanceModel>> markAttendance(AttendanceType type);

  /// Mendapatkan status absensi hari ini.
  Future<Either<Failure, TodayAttendanceStatus>> getTodayStatus();

  /// Stream riwayat absensi user.
  ///
  /// [limit] jumlah maksimal record yang diambil
  Stream<Either<Failure, List<AttendanceModel>>> getAttendanceHistory({
    int limit = 20,
  });

  /// Mendapatkan absensi berdasarkan rentang tanggal.
  Future<Either<Failure, List<AttendanceModel>>> getAttendanceByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  });
}
