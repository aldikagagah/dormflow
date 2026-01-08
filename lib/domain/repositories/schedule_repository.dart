/// Schedule Repository Interface
library;

import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../data/models/schedule_model.dart';

/// Interface repository untuk jadwal.
abstract class ScheduleRepository {
  /// Menambahkan jadwal baru.
  Future<Either<Failure, ScheduleModel>> addSchedule({
    required String taskName,
    required String category,
    required String assignedMemberId,
    required String assignedMemberName,
    required DateTime date,
  });

  /// Mengupdate jadwal.
  Future<Either<Failure, void>> updateSchedule({
    required String id,
    String? taskName,
    String? category,
    String? assignedMemberId,
    String? assignedMemberName,
    DateTime? date,
    ScheduleStatus? status,
  });

  /// Menghapus jadwal.
  Future<Either<Failure, void>> deleteSchedule(String id);

  /// Menandai jadwal sebagai selesai.
  Future<Either<Failure, void>> markAsCompleted(String id);

  /// Stream jadwal untuk rentang tanggal (week view).
  Stream<Either<Failure, List<ScheduleModel>>> getSchedulesStream({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Stream jadwal untuk hari ini.
  Stream<Either<Failure, List<ScheduleModel>>> getTodaySchedulesStream();

  /// Stream jadwal untuk tanggal tertentu.
  Stream<Either<Failure, List<ScheduleModel>>> getSchedulesForDate(DateTime date);

  /// Mendapatkan semua member yang bisa ditugaskan.
  Future<Either<Failure, List<MemberModel>>> getMembers();
}
