/// Finance Repository Interface
library;

import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../data/models/transaction_model.dart';

/// Interface repository untuk keuangan.
abstract class FinanceRepository {
  /// Menambahkan transaksi baru.
  Future<Either<Failure, TransactionModel>> addTransaction({
    required TransactionType type,
    required String category,
    required double amount,
    required String description,
    required DateTime date,
  });

  /// Mengupdate transaksi.
  Future<Either<Failure, void>> updateTransaction({
    required String id,
    TransactionType? type,
    String? category,
    double? amount,
    String? description,
    DateTime? date,
  });

  /// Menghapus transaksi.
  Future<Either<Failure, void>> deleteTransaction(String id);

  /// Stream transaksi untuk bulan tertentu.
  Stream<Either<Failure, List<TransactionModel>>> getTransactionsStream(
    DateTime month,
  );

  /// Stream ringkasan keuangan bulanan.
  Stream<Either<Failure, MonthlySummary>> getSummaryStream(DateTime month);

  /// Mendapatkan transaksi berdasarkan ID.
  Future<Either<Failure, TransactionModel>> getTransactionById(String id);
}
