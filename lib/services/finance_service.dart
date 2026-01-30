import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class FinanceService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  /// Adds a new transaction.
  Future<String> addTransaction({
    required String type, // "Pemasukan" or "Pengeluaran"
    required String category,
    required double amount,
    required String description,
    required DateTime date,
  }) async {
    try {
      final user = currentUser;
      if (user == null) return 'User not logged in';

      await _db.collection('transactions').add({
        'userId': user.uid,
        'type': type,
        'category': category,
        'amount': amount,
        'description': description,
        'date': Timestamp.fromDate(date),
        'timestamp': FieldValue.serverTimestamp(),
        'monthYear': DateFormat('yyyy-MM').format(date), // For filtering
      });

      return 'success';
    } catch (e) {
      return 'error: $e';
    }
  }

  /// Deletes a transaction.
  Future<String> deleteTransaction(String id) async {
    try {
      await _db.collection('transactions').doc(id).delete();
      return 'success';
    } catch (e) {
      return 'error: $e';
    }
  }

  /// Updates a transaction.
  Future<String> updateTransaction(String id, Map<String, dynamic> data) async {
    try {
      await _db.collection('transactions').doc(id).update(data);
      return 'success';
    } catch (e) {
      return 'error: $e';
    }
  }

  /// Stream of transactions for a specific month.
  Stream<List<Map<String, dynamic>>> getTransactionsStream(DateTime month) {
    final user = currentUser;
    if (user == null) return Stream.value([]);

    final monthStr = DateFormat('yyyy-MM').format(month);

    // Simple query without orderBy to avoid needing composite index
    return _db
        .collection('transactions')
        .where('userId', isEqualTo: user.uid)
        .where('monthYear', isEqualTo: monthStr)
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs.map((doc) {
            final data = doc.data();
            DateTime date;
            try {
              date = (data['date'] as Timestamp).toDate();
            } catch (e) {
              date = DateTime.now();
            }
            return {
              'id': doc.id,
              ...data,
              'date': date,
            };
          }).toList();
          // Sort client-side (newest first)
          list.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
          return list;
        });
  }

  /// Stream to calculate totals for a month.
  Stream<Map<String, double>> getSummaryStream(DateTime month) {
    return getTransactionsStream(month).map((transactions) {
      double income = 0;
      double expense = 0;

      for (final t in transactions) {
        if (t['type'] == 'Pemasukan') {
          income += (t['amount'] as num).toDouble();
        } else {
          expense += (t['amount'] as num).toDouble();
        }
      }

      return {
        'income': income,
        'expense': expense,
        'balance': income - expense,
      };
    });
  }
}
