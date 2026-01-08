/// Transaction Model untuk DormFlow Mobile
library;

// ignore_for_file: sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

/// Tipe transaksi.
enum TransactionType {
  @JsonValue('Pemasukan')
  pemasukan,
  @JsonValue('Pengeluaran')
  pengeluaran,
}

/// Kategori transaksi pemasukan.
enum IncomeCategory {
  gaji('Gaji'),
  bonus('Bonus'),
  investasi('Investasi'),
  hadiah('Hadiah'),
  lainnya('Lainnya');

  const IncomeCategory(this.label);
  final String label;
}

/// Kategori transaksi pengeluaran.
enum ExpenseCategory {
  makan('Makan'),
  transportasi('Transportasi'),
  belanja('Belanja'),
  tagihan('Tagihan'),
  hiburan('Hiburan'),
  kesehatan('Kesehatan'),
  pendidikan('Pendidikan'),
  lainnya('Lainnya');

  const ExpenseCategory(this.label);
  final String label;
}

/// Model data transaksi keuangan.
@freezed
class TransactionModel with _$TransactionModel {

  const factory TransactionModel({
    /// Document ID dari Firestore
    required String id,

    /// User ID pemilik transaksi
    required String userId,

    /// Tipe transaksi: Pemasukan atau Pengeluaran
    required TransactionType type,

    /// Kategori transaksi
    required String category,

    /// Jumlah uang
    required double amount,

    /// Deskripsi/catatan transaksi
    @Default('') String description,

    /// Tanggal transaksi
    required DateTime date,

    /// Bulan-tahun untuk filtering (yyyy-MM)
    required String monthYear,

    /// Timestamp pembuatan
    DateTime? createdAt,
  }) = _TransactionModel;
  const TransactionModel._();

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  /// Factory untuk membuat TransactionModel dari Firestore DocumentSnapshot.
  factory TransactionModel.fromFirestore(
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
      createdAt = (data['timestamp'] as Timestamp?)?.toDate();
    } catch (_) {
      createdAt = null;
    }

    return TransactionModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      type: (data['type'] as String?) == 'Pemasukan'
          ? TransactionType.pemasukan
          : TransactionType.pengeluaran,
      category: data['category'] as String? ?? 'Lainnya',
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      description: data['description'] as String? ?? '',
      date: date,
      monthYear: data['monthYear'] as String? ?? DateFormat('yyyy-MM').format(date),
      createdAt: createdAt,
    );
  }

  /// Konversi ke Map untuk disimpan ke Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'type': type == TransactionType.pemasukan ? 'Pemasukan' : 'Pengeluaran',
      'category': category,
      'amount': amount,
      'description': description,
      'date': Timestamp.fromDate(date),
      'monthYear': monthYear,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }

  /// Mendapatkan amount dengan format currency.
  String get formattedAmount {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Mendapatkan tanggal dalam format readable.
  String get formattedDate => DateFormat('dd MMM yyyy').format(date);

  /// Mendapatkan tanggal dalam format singkat.
  String get shortDate => DateFormat('dd/MM').format(date);

  /// Cek apakah transaksi ini adalah pemasukan.
  bool get isIncome => type == TransactionType.pemasukan;

  /// Cek apakah transaksi ini adalah pengeluaran.
  bool get isExpense => type == TransactionType.pengeluaran;
}

/// Model untuk ringkasan keuangan bulanan.
@freezed
class MonthlySummary with _$MonthlySummary {

  const factory MonthlySummary({
    /// Total pemasukan
    @Default(0.0) double income,

    /// Total pengeluaran
    @Default(0.0) double expense,

    /// Saldo (income - expense)
    @Default(0.0) double balance,

    /// Jumlah transaksi
    @Default(0) int transactionCount,
  }) = _MonthlySummary;
  const MonthlySummary._();

  factory MonthlySummary.fromJson(Map<String, dynamic> json) =>
      _$MonthlySummaryFromJson(json);

  /// Factory untuk menghitung summary dari list transaksi.
  factory MonthlySummary.fromTransactions(List<TransactionModel> transactions) {
    double income = 0;
    double expense = 0;

    for (final t in transactions) {
      if (t.isIncome) {
        income += t.amount;
      } else {
        expense += t.amount;
      }
    }

    return MonthlySummary(
      income: income,
      expense: expense,
      balance: income - expense,
      transactionCount: transactions.length,
    );
  }

  /// Format income dengan currency.
  String get formattedIncome => _format(income);

  /// Format expense dengan currency.
  String get formattedExpense => _format(expense);

  /// Format balance dengan currency.
  String get formattedBalance => _format(balance);

  String _format(double value) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }
}
