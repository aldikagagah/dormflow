import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ScheduleService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  /// Adds a new schedule.
  Future<String> addSchedule({
    required String taskName,
    required String category, // "Piket", "Ngaji", "Pemateri"
    required String assignedMemberId,
    required String assignedMemberName,
    required DateTime date,
  }) async {
    try {
      final user = currentUser;
      if (user == null) return 'User not logged in';

      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final weekNumber = _getWeekNumber(date);

      await _db.collection('schedules').add({
        'taskName': taskName,
        'category': category,
        'assignedMemberId': assignedMemberId,
        'assignedMemberName': assignedMemberName,
        'date': Timestamp.fromDate(date),
        'dateString': dateStr,
        'weekNumber': weekNumber,
        'status': 'Pending',
        'createdBy': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return 'success';
    } catch (e) {
      return 'error: $e';
    }
  }

  /// Updates an existing schedule.
  Future<String> updateSchedule(String id, Map<String, dynamic> data) async {
    try {
      await _db.collection('schedules').doc(id).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return 'success';
    } catch (e) {
      return 'error: $e';
    }
  }

  /// Deletes a schedule.
  Future<String> deleteSchedule(String id) async {
    try {
      await _db.collection('schedules').doc(id).delete();
      return 'success';
    } catch (e) {
      return 'error: $e';
    }
  }

  /// Marks a schedule as completed.
  Future<String> markAsCompleted(String id) async {
    return updateSchedule(id, {'status': 'Selesai'});
  }

  /// Stream of schedules for a specific date range (week view).
  Stream<List<Map<String, dynamic>>> getSchedulesStream(DateTime startDate, DateTime endDate) {
    final startStr = DateFormat('yyyy-MM-dd').format(startDate);
    final endStr = DateFormat('yyyy-MM-dd').format(endDate);

    // Simple query without orderBy to avoid needing composite index
    return _db
        .collection('schedules')
        .where('dateString', isGreaterThanOrEqualTo: startStr)
        .where('dateString', isLessThanOrEqualTo: endStr)
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'id': doc.id,
              ...data,
              'date': (data['date'] as Timestamp).toDate(),
            };
          }).toList();
          // Sort client-side
          list.sort((a, b) => (a['dateString'] as String).compareTo(b['dateString'] as String));
          return list;
        });
  }

  /// Get schedules for today.
  Stream<List<Map<String, dynamic>>> getTodaySchedulesStream() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return getSchedulesStream(startOfDay, endOfDay);
  }

  /// Get schedules for a specific date.
  Stream<List<Map<String, dynamic>>> getSchedulesForDate(DateTime date) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);

    // Simple query without orderBy to avoid needing composite index
    return _db
        .collection('schedules')
        .where('dateString', isEqualTo: dateStr)
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'id': doc.id,
              ...data,
              'date': (data['date'] as Timestamp).toDate(),
            };
          }).toList();
          return list;
        });
  }

  /// Get all members from users collection.
  Future<List<Map<String, dynamic>>> getMembers() async {
    try {
      final snapshot = await _db.collection('users').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] ?? 'Unknown',
          'email': data['email'] ?? '',
        };
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Calculate ISO week number.
  int _getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year);
    final daysDiff = date.difference(firstDayOfYear).inDays;
    return ((daysDiff + firstDayOfYear.weekday) / 7).ceil();
  }

  /// Get start of the week (Monday).
  DateTime getStartOfWeek(DateTime date) {
    final daysToSubtract = date.weekday - 1;
    return DateTime(date.year, date.month, date.day - daysToSubtract);
  }

  /// Get end of the week (Sunday).
  DateTime getEndOfWeek(DateTime date) {
    final daysToAdd = 7 - date.weekday;
    return DateTime(date.year, date.month, date.day + daysToAdd);
  }
}
