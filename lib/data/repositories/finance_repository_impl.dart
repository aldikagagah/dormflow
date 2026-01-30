/// Finance Repository Implementation
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_constants.dart';
import '../../core/error/failures.dart';
import '../../domain/repositories/finance_repository.dart';
import '../models/transaction_model.dart';

/// Implementasi FinanceRepository menggunakan Firebase.
class FinanceRepositoryImpl implements FinanceRepository {

  FinanceRepositoryImpl({
    required fb.FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;
  final fb.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  fb.User? get _currentUser => _firebaseAuth.currentUser;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestoreCollections.transactions);

  @override
  Future<Either<Failure, TransactionModel>> addTransaction({
    required TransactionType type,
    required String category,
    required double amount,
    required String description,
    required DateTime date,
  }) async {
    try {
      final user = _currentUser;
      if (user == null) {
        return const Left(AuthFailure('User tidak login'));
      }

      final monthYear = DateFormat('yyyy-MM').format(date);

      final transaction = TransactionModel(
        id: '', // akan diisi setelah add
        userId: user.uid,
        type: type,
        category: category,
        amount: amount,
        description: description,
        date: date,
        monthYear: monthYear,
      );

      final docRef = await _collection.add(transaction.toFirestore());

      return Right(transaction.copyWith(id: docRef.id));
    } catch (e) {
      debugPrint('Add transaction error: $e');
      return Left(ServerFailure('Gagal menambah transaksi: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateTransaction({
    required String id,
    TransactionType? type,
    String? category,
    double? amount,
    String? description,
    DateTime? date,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (type != null) {
        updateData['type'] = type == TransactionType.pemasukan
            ? 'Pemasukan'
            : 'Pengeluaran';
      }
      if (category != null) updateData['category'] = category;
      if (amount != null) updateData['amount'] = amount;
      if (description != null) updateData['description'] = description;
      if (date != null) {
        updateData['date'] = Timestamp.fromDate(date);
        updateData['monthYear'] = DateFormat('yyyy-MM').format(date);
      }

      await _collection.doc(id).update(updateData);
      return const Right(null);
    } catch (e) {
      debugPrint('Update transaction error: $e');
      return Left(ServerFailure('Gagal update transaksi: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    try {
      await _collection.doc(id).delete();
      return const Right(null);
    } catch (e) {
      debugPrint('Delete transaction error: $e');
      return Left(ServerFailure('Gagal hapus transaksi: $e'));
    }
  }

  @override
  Stream<Either<Failure, List<TransactionModel>>> getTransactionsStream(
    DateTime month,
  ) {
    final user = _currentUser;
    if (user == null) {
      return Stream.value(const Left(AuthFailure('User tidak login')));
    }

    final monthStr = DateFormat('yyyy-MM').format(month);

    return _collection
        .where(FirestoreFields.userId, isEqualTo: user.uid)
        .where(FirestoreFields.monthYear, isEqualTo: monthStr)
        .snapshots()
        .map((snapshot) {
      try {
        final list = snapshot.docs
            .map((doc) => TransactionModel.fromFirestore(doc))
            .toList();

        // Sort client-side (newest first)
        list.sort((a, b) => b.date.compareTo(a.date));

        return Right(list);
      } catch (e) {
        return Left(ServerFailure('Gagal memproses data: $e'));
      }
    });
  }

  @override
  Stream<Either<Failure, MonthlySummary>> getSummaryStream(DateTime month) {
    return getTransactionsStream(month).map((result) {
      return result.fold(
        (failure) => Left(failure),
        (transactions) => Right(MonthlySummary.fromTransactions(transactions)),
      );
    });
  }

  @override
  Future<Either<Failure, TransactionModel>> getTransactionById(String id) async {
    try {
      final doc = await _collection.doc(id).get();

      if (!doc.exists) {
        return const Left(NotFoundFailure('Transaksi tidak ditemukan'));
      }

      return Right(TransactionModel.fromFirestore(doc));
    } catch (e) {
      debugPrint('Get transaction error: $e');
      return Left(ServerFailure('Gagal mengambil transaksi: $e'));
    }
  }
}
