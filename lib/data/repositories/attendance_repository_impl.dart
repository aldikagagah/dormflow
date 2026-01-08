/// Attendance Repository Implementation
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_constants.dart';
import '../../core/error/failures.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../models/attendance_model.dart';

/// Implementasi AttendanceRepository menggunakan Firebase.
class AttendanceRepositoryImpl implements AttendanceRepository {

  AttendanceRepositoryImpl({
    required fb.FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;
  final fb.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  fb.User? get _currentUser => _firebaseAuth.currentUser;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestoreCollections.attendance);

  @override
  Future<Either<Failure, AttendanceModel>> markAttendance(
    AttendanceType type,
  ) async {
    try {
      final user = _currentUser;
      if (user == null) {
        return const Left(AuthFailure('User tidak login'));
      }

      final now = DateTime.now();
      final dateStr = DateFormat('yyyy-MM-dd').format(now);

      // Cek duplikat untuk masuk
      if (type == AttendanceType.masuk) {
        final existing = await _collection
            .where(FirestoreFields.userId, isEqualTo: user.uid)
            .where(FirestoreFields.date, isEqualTo: dateStr)
            .where(FirestoreFields.type, isEqualTo: 'Masuk')
            .get();

        if (existing.docs.isNotEmpty) {
          return const Left(ValidationFailure('Sudah absen masuk hari ini'));
        }
      }

      // Cek harus masuk dulu sebelum keluar
      if (type == AttendanceType.keluar) {
        final checkIn = await _collection
            .where(FirestoreFields.userId, isEqualTo: user.uid)
            .where(FirestoreFields.date, isEqualTo: dateStr)
            .where(FirestoreFields.type, isEqualTo: 'Masuk')
            .get();

        if (checkIn.docs.isEmpty) {
          return const Left(ValidationFailure('Harus absen masuk terlebih dahulu'));
        }

        // Cek sudah keluar
        final existing = await _collection
            .where(FirestoreFields.userId, isEqualTo: user.uid)
            .where(FirestoreFields.date, isEqualTo: dateStr)
            .where(FirestoreFields.type, isEqualTo: 'Keluar')
            .get();

        if (existing.docs.isNotEmpty) {
          return const Left(ValidationFailure('Sudah absen keluar hari ini'));
        }
      }

      // Tentukan status
      AttendanceStatus status;
      if (type == AttendanceType.masuk) {
        final isLate = now.hour > AppConstants.lateThresholdHour ||
            (now.hour == AppConstants.lateThresholdHour &&
                now.minute > AppConstants.lateThresholdMinute);
        status = isLate ? AttendanceStatus.terlambat : AttendanceStatus.hadir;
      } else {
        status = AttendanceStatus.selesai;
      }

      final attendance = AttendanceModel(
        id: '', // akan diisi setelah add
        userId: user.uid,
        userEmail: user.email,
        type: type,
        timestamp: now,
        date: dateStr,
        status: status,
        localTime: now.toIso8601String(),
      );

      final docRef = await _collection.add(attendance.toFirestore());

      return Right(attendance.copyWith(id: docRef.id));
    } catch (e) {
      debugPrint('Mark attendance error: $e');
      return Left(ServerFailure('Gagal mencatat absensi: $e'));
    }
  }

  @override
  Future<Either<Failure, TodayAttendanceStatus>> getTodayStatus() async {
    try {
      final user = _currentUser;
      if (user == null) {
        return const Left(AuthFailure('User tidak login'));
      }

      final now = DateTime.now();
      final dateStr = DateFormat('yyyy-MM-dd').format(now);

      final snapshot = await _collection
          .where(FirestoreFields.userId, isEqualTo: user.uid)
          .where(FirestoreFields.date, isEqualTo: dateStr)
          .get();

      String? checkInTime;
      String? checkOutTime;
      AttendanceStatus status = AttendanceStatus.belumAbsen;

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final time = DateTime.parse(data[FirestoreFields.localTime] as String);
        final formattedTime = DateFormat('hh:mm a').format(time);

        if (data[FirestoreFields.type] == 'Masuk') {
          checkInTime = formattedTime;
          final statusStr = data[FirestoreFields.status] as String?;
          if (statusStr == 'Terlambat') {
            status = AttendanceStatus.terlambat;
          } else {
            status = AttendanceStatus.hadir;
          }
        } else if (data[FirestoreFields.type] == 'Keluar') {
          checkOutTime = formattedTime;
        }
      }

      return Right(TodayAttendanceStatus(
        checkInTime: checkInTime,
        checkOutTime: checkOutTime,
        status: status,
        hasCheckedIn: checkInTime != null,
        hasCheckedOut: checkOutTime != null,
      ));
    } catch (e) {
      debugPrint('Get today status error: $e');
      return Left(ServerFailure('Gagal mengambil status: $e'));
    }
  }

  @override
  Stream<Either<Failure, List<AttendanceModel>>> getAttendanceHistory({
    int limit = 20,
  }) {
    final user = _currentUser;
    if (user == null) {
      return Stream.value(const Left(AuthFailure('User tidak login')));
    }

    return _collection
        .where(FirestoreFields.userId, isEqualTo: user.uid)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      try {
        final list = snapshot.docs
            .map((doc) => AttendanceModel.fromFirestore(doc))
            .toList();

        // Sort client-side (newest first)
        list.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        return Right(list);
      } catch (e) {
        return Left(ServerFailure('Gagal memproses data: $e'));
      }
    });
  }

  @override
  Future<Either<Failure, List<AttendanceModel>>> getAttendanceByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final user = _currentUser;
      if (user == null) {
        return const Left(AuthFailure('User tidak login'));
      }

      final startStr = DateFormat('yyyy-MM-dd').format(startDate);
      final endStr = DateFormat('yyyy-MM-dd').format(endDate);

      final snapshot = await _collection
          .where(FirestoreFields.userId, isEqualTo: user.uid)
          .where(FirestoreFields.date, isGreaterThanOrEqualTo: startStr)
          .where(FirestoreFields.date, isLessThanOrEqualTo: endStr)
          .get();

      final list = snapshot.docs
          .map((doc) => AttendanceModel.fromFirestore(doc))
          .toList();

      list.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return Right(list);
    } catch (e) {
      debugPrint('Get attendance by date range error: $e');
      return Left(ServerFailure('Gagal mengambil data: $e'));
    }
  }
}
