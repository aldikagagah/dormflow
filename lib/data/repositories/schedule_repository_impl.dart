/// Schedule Repository Implementation
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_constants.dart';
import '../../core/error/failures.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../models/schedule_model.dart';

/// Implementasi ScheduleRepository menggunakan Firebase.
class ScheduleRepositoryImpl implements ScheduleRepository {

  ScheduleRepositoryImpl({
    required fb.FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;
  final fb.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  fb.User? get _currentUser => _firebaseAuth.currentUser;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestoreCollections.schedules);

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection(FirestoreCollections.users);

  @override
  Future<Either<Failure, ScheduleModel>> addSchedule({
    required String taskName,
    required String category,
    required String assignedMemberId,
    required String assignedMemberName,
    required DateTime date,
  }) async {
    try {
      final user = _currentUser;
      if (user == null) {
        return const Left(AuthFailure('User tidak login'));
      }

      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final weekNumber = _getWeekNumber(date);

      final schedule = ScheduleModel(
        id: '', // akan diisi setelah add
        taskName: taskName,
        category: category,
        assignedMemberId: assignedMemberId,
        assignedMemberName: assignedMemberName,
        date: date,
        dateString: dateStr,
        weekNumber: weekNumber,
        createdBy: user.uid,
      );

      final docRef = await _collection.add(schedule.toFirestore());

      return Right(schedule.copyWith(id: docRef.id));
    } catch (e) {
      debugPrint('Add schedule error: $e');
      return Left(ServerFailure('Gagal menambah jadwal: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateSchedule({
    required String id,
    String? taskName,
    String? category,
    String? assignedMemberId,
    String? assignedMemberName,
    DateTime? date,
    ScheduleStatus? status,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (taskName != null) updateData['taskName'] = taskName;
      if (category != null) updateData['category'] = category;
      if (assignedMemberId != null) updateData['assignedMemberId'] = assignedMemberId;
      if (assignedMemberName != null) updateData['assignedMemberName'] = assignedMemberName;
      if (date != null) {
        updateData['date'] = Timestamp.fromDate(date);
        updateData['dateString'] = DateFormat('yyyy-MM-dd').format(date);
        updateData['weekNumber'] = _getWeekNumber(date);
      }
      if (status != null) {
        updateData['status'] = status == ScheduleStatus.selesai ? 'Selesai' : 'Pending';
      }

      await _collection.doc(id).update(updateData);
      return const Right(null);
    } catch (e) {
      debugPrint('Update schedule error: $e');
      return Left(ServerFailure('Gagal update jadwal: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSchedule(String id) async {
    try {
      await _collection.doc(id).delete();
      return const Right(null);
    } catch (e) {
      debugPrint('Delete schedule error: $e');
      return Left(ServerFailure('Gagal hapus jadwal: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> markAsCompleted(String id) async {
    return updateSchedule(id: id, status: ScheduleStatus.selesai);
  }

  @override
  Stream<Either<Failure, List<ScheduleModel>>> getSchedulesStream({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final startStr = DateFormat('yyyy-MM-dd').format(startDate);
    final endStr = DateFormat('yyyy-MM-dd').format(endDate);

    return _collection
        .where(FirestoreFields.dateString, isGreaterThanOrEqualTo: startStr)
        .where(FirestoreFields.dateString, isLessThanOrEqualTo: endStr)
        .snapshots()
        .map((snapshot) {
      try {
        final list = snapshot.docs
            .map((doc) => ScheduleModel.fromFirestore(doc))
            .toList();

        // Sort client-side by date
        list.sort((a, b) => a.dateString.compareTo(b.dateString));

        return Right(list);
      } catch (e) {
        return Left(ServerFailure('Gagal memproses data: $e'));
      }
    });
  }

  @override
  Stream<Either<Failure, List<ScheduleModel>>> getTodaySchedulesStream() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return getSchedulesStream(startDate: startOfDay, endDate: endOfDay);
  }

  @override
  Stream<Either<Failure, List<ScheduleModel>>> getSchedulesForDate(DateTime date) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);

    return _collection
        .where(FirestoreFields.dateString, isEqualTo: dateStr)
        .snapshots()
        .map((snapshot) {
      try {
        final list = snapshot.docs
            .map((doc) => ScheduleModel.fromFirestore(doc))
            .toList();
        return Right(list);
      } catch (e) {
        return Left(ServerFailure('Gagal memproses data: $e'));
      }
    });
  }

  @override
  Future<Either<Failure, List<MemberModel>>> getMembers() async {
    try {
      final snapshot = await _usersCollection.get();

      final members = snapshot.docs
          .map((doc) => MemberModel.fromFirestore(doc))
          .toList();

      return Right(members);
    } catch (e) {
      debugPrint('Get members error: $e');
      return Left(ServerFailure('Gagal mengambil data member: $e'));
    }
  }

  int _getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year);
    final daysDiff = date.difference(firstDayOfYear).inDays;
    return ((daysDiff + firstDayOfYear.weekday) / 7).ceil();
  }
}
