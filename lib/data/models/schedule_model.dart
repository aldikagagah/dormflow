/// Schedule Model untuk DormFlow Mobile
library;

// ignore_for_file: sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'schedule_model.freezed.dart';
part 'schedule_model.g.dart';

/// Kategori jadwal.
enum ScheduleCategory {
  piket('Piket'),
  ngaji('Ngaji'),
  pemateri('Pemateri'),
  rapat('Rapat'),
  kegiatan('Kegiatan'),
  lainnya('Lainnya');

  const ScheduleCategory(this.label);
  final String label;
}

/// Status jadwal.
enum ScheduleStatus {
  @JsonValue('Pending')
  pending,
  @JsonValue('Selesai')
  selesai,
}

/// Model data jadwal.
@freezed
class ScheduleModel with _$ScheduleModel {

  const factory ScheduleModel({
    /// Document ID dari Firestore
    required String id,

    /// Nama tugas/kegiatan
    required String taskName,

    /// Kategori jadwal
    required String category,

    /// ID member yang ditugaskan
    required String assignedMemberId,

    /// Nama member yang ditugaskan
    required String assignedMemberName,

    /// Tanggal jadwal
    required DateTime date,

    /// Tanggal dalam format string (yyyy-MM-dd)
    required String dateString,

    /// Nomor minggu dalam tahun
    required int weekNumber,

    /// Status jadwal
    @Default(ScheduleStatus.pending) ScheduleStatus status,

    /// User ID pembuat jadwal
    String? createdBy,

    /// Timestamp pembuatan
    DateTime? createdAt,

    /// Timestamp update terakhir
    DateTime? updatedAt,
  }) = _ScheduleModel;
  const ScheduleModel._();

  factory ScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleModelFromJson(json);

  /// Factory untuk membuat ScheduleModel dari Firestore DocumentSnapshot.
  factory ScheduleModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    DateTime date;
    try {
      date = (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();
    } catch (_) {
      date = DateTime.now();
    }

    DateTime? createdAt;
    try {
      createdAt = (data['createdAt'] as Timestamp?)?.toDate();
    } catch (_) {
      createdAt = null;
    }

    return ScheduleModel(
      id: doc.id,
      taskName: data['taskName'] as String? ?? '',
      category: data['category'] as String? ?? 'Lainnya',
      assignedMemberId: data['assignedMemberId'] as String? ?? '',
      assignedMemberName: data['assignedMemberName'] as String? ?? '',
      date: date,
      dateString: data['dateString'] as String? ?? DateFormat('yyyy-MM-dd').format(date),
      weekNumber: data['weekNumber'] as int? ?? _calculateWeekNumber(date),
      status: _parseStatus(data['status'] as String?),
      createdBy: data['createdBy'] as String?,
      createdAt: createdAt,
    );
  }

  /// Konversi ke Map untuk disimpan ke Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'taskName': taskName,
      'category': category,
      'assignedMemberId': assignedMemberId,
      'assignedMemberName': assignedMemberName,
      'date': Timestamp.fromDate(date),
      'dateString': dateString,
      'weekNumber': weekNumber,
      'status': status == ScheduleStatus.selesai ? 'Selesai' : 'Pending',
      if (createdBy != null) 'createdBy': createdBy,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  /// Mendapatkan tanggal dalam format readable.
  String get formattedDate => DateFormat('dd MMM yyyy').format(date);

  /// Mendapatkan nama hari.
  String get dayName => DateFormat('EEEE', 'id_ID').format(date);

  /// Mendapatkan tanggal singkat.
  String get shortDate => DateFormat('dd/MM').format(date);

  /// Cek apakah jadwal ini sudah selesai.
  bool get isCompleted => status == ScheduleStatus.selesai;

  /// Cek apakah jadwal ini untuk hari ini.
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day;
  }

  /// Cek apakah jadwal sudah lewat.
  bool get isPast {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final scheduleDate = DateTime(date.year, date.month, date.day);
    return scheduleDate.isBefore(today);
  }

  static ScheduleStatus _parseStatus(String? status) {
    if (status == 'Selesai') return ScheduleStatus.selesai;
    return ScheduleStatus.pending;
  }

  static int _calculateWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year);
    final daysDiff = date.difference(firstDayOfYear).inDays;
    return ((daysDiff + firstDayOfYear.weekday) / 7).ceil();
  }
}

/// Model untuk member yang bisa ditugaskan.
@freezed
class MemberModel with _$MemberModel {
  const factory MemberModel({
    required String id,
    required String name,
    @Default('') String email,
  }) = _MemberModel;

  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);

  /// Factory dari Firestore document.
  factory MemberModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return MemberModel(
      id: doc.id,
      name: data['name'] as String? ?? 'Unknown',
      email: data['email'] as String? ?? '',
    );
  }
}
