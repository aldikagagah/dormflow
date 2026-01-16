/// Unit tests for TransactionModel
library;

import 'package:dormflow_mobile/data/models/transaction_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransactionType', () {
    test('should have correct values', () {
      expect(TransactionType.pemasukan.name, 'pemasukan');
      expect(TransactionType.pengeluaran.name, 'pengeluaran');
    });
  });

  group('IncomeCategory', () {
    test('should have correct labels', () {
      expect(IncomeCategory.gaji.label, 'Gaji');
      expect(IncomeCategory.bonus.label, 'Bonus');
      expect(IncomeCategory.investasi.label, 'Investasi');
      expect(IncomeCategory.hadiah.label, 'Hadiah');
      expect(IncomeCategory.lainnya.label, 'Lainnya');
    });
  });

  group('ExpenseCategory', () {
    test('should have correct labels', () {
      expect(ExpenseCategory.makan.label, 'Makan');
      expect(ExpenseCategory.transportasi.label, 'Transportasi');
      expect(ExpenseCategory.belanja.label, 'Belanja');
      expect(ExpenseCategory.tagihan.label, 'Tagihan');
      expect(ExpenseCategory.hiburan.label, 'Hiburan');
      expect(ExpenseCategory.kesehatan.label, 'Kesehatan');
      expect(ExpenseCategory.pendidikan.label, 'Pendidikan');
      expect(ExpenseCategory.lainnya.label, 'Lainnya');
    });
  });

  group('TransactionModel', () {
    late TransactionModel incomeTransaction;
    late TransactionModel expenseTransaction;
    late DateTime testDate;

    setUp(() {
      testDate = DateTime(2026, 1, 15);
      incomeTransaction = TransactionModel(
        id: 'tx-income-123',
        userId: 'user-1',
        type: TransactionType.pemasukan,
        category: 'Gaji',
        amount: 5000000,
        description: 'Gaji bulan Januari',
        date: testDate,
        monthYear: '2026-01',
      );

      expenseTransaction = TransactionModel(
        id: 'tx-expense-456',
        userId: 'user-1',
        type: TransactionType.pengeluaran,
        category: 'Makan',
        amount: 50000,
        description: 'Makan siang',
        date: testDate,
        monthYear: '2026-01',
      );
    });

    test('should create a valid income TransactionModel', () {
      expect(incomeTransaction.id, 'tx-income-123');
      expect(incomeTransaction.userId, 'user-1');
      expect(incomeTransaction.type, TransactionType.pemasukan);
      expect(incomeTransaction.category, 'Gaji');
      expect(incomeTransaction.amount, 5000000);
      expect(incomeTransaction.description, 'Gaji bulan Januari');
      expect(incomeTransaction.date, testDate);
      expect(incomeTransaction.monthYear, '2026-01');
    });

    test('should create a valid expense TransactionModel', () {
      expect(expenseTransaction.id, 'tx-expense-456');
      expect(expenseTransaction.type, TransactionType.pengeluaran);
      expect(expenseTransaction.category, 'Makan');
      expect(expenseTransaction.amount, 50000);
    });

    test('formattedAmount should return currency format', () {
      expect(incomeTransaction.formattedAmount, contains('Rp'));
      expect(incomeTransaction.formattedAmount, contains('5'));
    });

    test('formattedDate should return readable date', () {
      expect(incomeTransaction.formattedDate, '15 Jan 2026');
    });

    test('shortDate should return short format', () {
      expect(incomeTransaction.shortDate, '15/01');
    });

    test('isIncome should return true for pemasukan', () {
      expect(incomeTransaction.isIncome, true);
      expect(incomeTransaction.isExpense, false);
    });

    test('isExpense should return true for pengeluaran', () {
      expect(expenseTransaction.isExpense, true);
      expect(expenseTransaction.isIncome, false);
    });

    test('description should default to empty string', () {
      final transaction = TransactionModel(
        id: 'tx-test',
        userId: 'user-1',
        type: TransactionType.pemasukan,
        category: 'Bonus',
        amount: 100000,
        date: testDate,
        monthYear: '2026-01',
      );
      expect(transaction.description, '');
    });

    test('toJson should work correctly', () {
      final json = incomeTransaction.toJson();
      expect(json['id'], 'tx-income-123');
      expect(json['amount'], 5000000);
      expect(json['category'], 'Gaji');
    });

    test('fromJson should work correctly', () {
      final json = {
        'id': 'test-tx',
        'userId': 'user-test',
        'type': 'Pemasukan',
        'category': 'Bonus',
        'amount': 250000,
        'description': 'Test desc',
        'date': '2026-01-15T00:00:00.000',
        'monthYear': '2026-01',
      };
      final model = TransactionModel.fromJson(json);
      expect(model.id, 'test-tx');
      expect(model.amount, 250000);
    });
  });

  group('MonthlySummary', () {
    test('should create with default values', () {
      const summary = MonthlySummary();
      expect(summary.income, 0.0);
      expect(summary.expense, 0.0);
      expect(summary.balance, 0.0);
      expect(summary.transactionCount, 0);
    });

    test('should create with specified values', () {
      const summary = MonthlySummary(
        income: 10000000,
        expense: 5000000,
        balance: 5000000,
        transactionCount: 15,
      );
      expect(summary.income, 10000000);
      expect(summary.expense, 5000000);
      expect(summary.balance, 5000000);
      expect(summary.transactionCount, 15);
    });

    test('formattedIncome should return currency format', () {
      const summary = MonthlySummary(income: 5000000);
      expect(summary.formattedIncome, contains('Rp'));
    });

    test('formattedExpense should return currency format', () {
      const summary = MonthlySummary(expense: 3000000);
      expect(summary.formattedExpense, contains('Rp'));
    });

    test('formattedBalance should return currency format', () {
      const summary = MonthlySummary(balance: 2000000);
      expect(summary.formattedBalance, contains('Rp'));
    });

    test('fromTransactions should calculate correctly', () {
      final date = DateTime(2026, 1, 15);
      final transactions = [
        TransactionModel(
          id: 'tx-1',
          userId: 'user-1',
          type: TransactionType.pemasukan,
          category: 'Gaji',
          amount: 5000000,
          date: date,
          monthYear: '2026-01',
        ),
        TransactionModel(
          id: 'tx-2',
          userId: 'user-1',
          type: TransactionType.pemasukan,
          category: 'Bonus',
          amount: 1000000,
          date: date,
          monthYear: '2026-01',
        ),
        TransactionModel(
          id: 'tx-3',
          userId: 'user-1',
          type: TransactionType.pengeluaran,
          category: 'Makan',
          amount: 500000,
          date: date,
          monthYear: '2026-01',
        ),
      ];

      final summary = MonthlySummary.fromTransactions(transactions);
      expect(summary.income, 6000000);
      expect(summary.expense, 500000);
      expect(summary.balance, 5500000);
      expect(summary.transactionCount, 3);
    });

    test('fromTransactions should handle empty list', () {
      final summary = MonthlySummary.fromTransactions([]);
      expect(summary.income, 0);
      expect(summary.expense, 0);
      expect(summary.balance, 0);
      expect(summary.transactionCount, 0);
    });

    test('toJson and fromJson should work correctly', () {
      const summary = MonthlySummary(
        income: 5000000,
        expense: 2000000,
        balance: 3000000,
        transactionCount: 10,
      );

      final json = summary.toJson();
      final restored = MonthlySummary.fromJson(json);
      expect(restored.income, summary.income);
      expect(restored.expense, summary.expense);
      expect(restored.balance, summary.balance);
      expect(restored.transactionCount, summary.transactionCount);
    });
  });
}
