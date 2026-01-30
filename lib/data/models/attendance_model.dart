/// Attendance Model untuk DormFlow Mobile
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'attendance_model.freezed.dart';
part 'attendance_model.g.dart';

/// Tipe absensi.
enum AttendanceType {
  @JsonValue('Masuk')
  masuk,
  @JsonValue('Keluar')
  keluar,
}

/// Status absensi.
enum AttendanceStatus {
  @JsonValue('Hadir')
  hadir,
  @JsonValue('Terlambat')
  terlambat,
  @JsonValue('Selesai')
  selesai,
  @JsonValue('Belum Absen')
  belumAbsen,
}

/// Model data absensi.
@freezed
class AttendanceModel with _$AttendanceModel {

  const factory AttendanceModel({
    /// Document ID dari Firestore
    required String id,

    /// User ID pemilik absensi
    required String userId,

    /// Email user (untuk display)
    String? userEmail,

    /// Tipe absensi: Masuk atau Keluar
    required AttendanceType type,

    /// Timestamp dari server
    required DateTime timestamp,

    /// Tanggal dalam format yyyy-MM-dd
    required String date,

    /// Status absensi
    required AttendanceStatus status,

    /// Waktu lokal dalam ISO format
    String? localTime,
  }) = _AttendanceModel;
  const AttendanceModel._();

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceModelFromJson(json);

  /// Factory untuk membuat AttendanceModel dari Firestore DocumentSnapshot.
  factory AttendanceModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    DateTime timestamp;
    try {
      timestamp = (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
    } catch (_) {
      timestamp = DateTime.now();
    }

    return AttendanceModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      userEmail: data['userEmail'] as String?,
      type: _parseType(data['type'] as String?),
      timestamp: timestamp,
      date: data['date'] as String? ?? DateFormat('yyyy-MM-dd').format(timestamp),
      status: _parseStatus(data['status'] as String?),
      localTime: data['localTime'] as String?,
    );
  }

  /// Konversi ke Map untuk disimpan ke Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      if (userEmail != null) 'userEmail': userEmail,
      'type': type == AttendanceType.masuk ? 'Masuk' : 'Keluar',
      'timestamp': FieldValue.serverTimestamp(),
      'date': date,
      'status': _statusToString(status),
      'localTime': localTime ?? DateTime.now().toIso8601String(),
    };
  }

  /// Mendapatkan waktu dalam format yang readable.
  String get formattedTime => DateFormat('HH:mm').format(timestamp);

  /// Mendapatkan tanggal dalam format yang readable.
  String get formattedDate => DateFormat('dd MMM yyyy').format(timestamp);

  /// Mendapatkan waktu dalam format 12 jam.
  String get formattedTime12h => DateFormat('hh:mm a').format(timestamp);

  static AttendanceType _parseType(String? type) {
    if (type == 'Masuk') return AttendanceType.masuk;
    return AttendanceType.keluar;
  }

  static AttendanceStatus _parseStatus(String? status) {
    switch (status) {
      case 'Hadir':
        return AttendanceStatus.hadir;
      case 'Terlambat':
        return AttendanceStatus.terlambat;
      case 'Selesai':
        return AttendanceStatus.selesai;
      default:
        return AttendanceStatus.belumAbsen;
    }
  }

  static String _statusToString(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.hadir:
        return 'Hadir';
      case AttendanceStatus.terlambat:
        return 'Terlambat';
      case AttendanceStatus.selesai:
        return 'Selesai';
      case AttendanceStatus.belumAbsen:
        return 'Belum Absen';
    }
  }
}

/// Model untuk status absensi hari ini.
@freezed
class TodayAttendanceStatus with _$TodayAttendanceStatus {
  const factory TodayAttendanceStatus({
    /// Waktu check-in (null jika belum)
    String? checkInTime,

    /// Waktu check-out (null jika belum)
    String? checkOutTime,

    /// Status absensi hari ini
    @Default(AttendanceStatus.belumAbsen) AttendanceStatus status,

    /// Apakah sudah check-in
    @Default(false) bool hasCheckedIn,

    /// Apakah sudah check-out
    @Default(false) bool hasCheckedOut,
  }) = _TodayAttendanceStatus;

  factory TodayAttendanceStatus.fromJson(Map<String, dynamic> json) =>
      _$TodayAttendanceStatusFromJson(json);
}
